##
#
# Hierarchical Backend Selection
#
# - locate the requested file on alternative backends and cache them if found
# - always check backend "updates" first
#   - if the update backend returns 404/403, cache that response and restart the request
#   - next client request finds cached 404 and restarts immediately
# - hash on backend URL, not request URL
#   - every backend location has its unique key
#   - order of backends in vcl_recv is important
#
# requires cache_restart patch!
#
# must be included before error_restart.vcl, saintmode.vcl, errorpages_404.vcl
# or any other code that acts on backend responses without vhost restriction
# uses X-Orig-(URL|Host): to pass information between functions
# req.url must begin with "/", see common/normalize_http.vcl
##

# possible backend locations for http://images.example.com/foo.jpg
# http://example-updates.s3.amazonaws.com/foo.jpg
# http://static.example.com/images/foo.jpg
# http://archive.example.com/example/images/foo.jpg

#backend updates {
#	.host = "example-updates.s3.amazonaws.com";
#	.port = "80";
#}
#
#backend local {
#	.host = "127.0.0.1";
#	.port = "8080";
#}
#
#backend archive {
#	.host = "archive.example.com";
#	.port = "80";
#}


sub vcl_recv {
	# these headers are used internally. ignore them if set by the client
	unset req.http.X-Orig-URL;
	unset req.http.X-Orig-Host;

	# locate images
	if (req.http.Host ~ "(?i)^images\.example\.com$") {
		# save original request Host: and URL
		set req.http.X-Orig-URL = req.url;
		set req.http.X-Orig-Host = "images.example.com";
		unset req.http.Cookie;

		if (req.restarts == 0) {
			# try update backend first
			set req.backend = updates;
			set req.http.Host = "example-updates.s3.amazonaws.com";
		} else if (req.restarts == 1) {
			# try the static vhost if vcl_fetch restarted the request after a 403/404 response
			# maybe the file is in local storage
			set req.backend = local;
			set req.http.Host = "static.example.com";
			set req.url = regsub(req.url, "^/", "/images/");
		} else if (req.restarts == 2) {
			# if all else fails, try the archive backend
			set req.backend = archive;
			set req.http.Host = "archive.example.com";
			set req.url = regsub(req.url, "^/", "/example/images/");
			# archive access requires password
			set req.http.Authorization = "Basic dmFybmlzaHByb3h5OnNvbWVwYXNzd29yZA==";
		} else {
			# file not found on any backend
			error 404 "Not found";
		}

		# skip the rest and force hash lookup
		if (req.request == "GET" || req.request == "HEAD") {
			return (lookup);
		}
	}
}

sub vcl_fetch {
	# restore original request
	if (req.http.X-Orig-Host) {
		set req.http.Host = req.http.X-Orig-Host;
		unset req.http.X-Orig-Host;
	}

	if (req.http.X-Orig-URL) {
		set req.url = req.http.X-Orig-URL;
		unset req.http.X-Orig-URL;
	}

	if (req.http.Host == "images.example.com") {
		# Last-Modified and ETag don't make much sense for virtual files
		# TODO: maybe they do. think about IMS-handling in upcoming varnish release
		unset beresp.http.Last-Modified;
		unset beresp.http.ETag;

		# don't want any of these, either
		unset beresp.http.Cache-Control;
		unset beresp.http.Pragma;
		unset beresp.http.Expires;
		unset beresp.http.Set-Cookie;

		# TODO: - think about 304, 206 and other 2xx
		#       - what to do with 301/302?
		if (beresp.status == 200) {
			# the client should check back for updates
			# cache objects longer in varnish than in the client's cache
			set beresp.ttl = 31d;
			set beresp.http.Cache-Control = "public,max-age=43200";
			set beresp.http.X-Ageless = "yes";
		} else if (beresp.status == 403 || beresp.status == 404) {
			# cache 404 response
			set beresp.ttl = 3600s;
			# restart request and try next backend
			# vcl_recv should call error when it runs out of backends
			set beresp.http.X-ReqRestart = "yes";
			return (restart);
		} else {
			# unexpected response. try next backend
			set beresp.ttl = 0s;
			return (restart);
		}
	}
}

sub vcl_hit {
	if (obj.http.X-ReqRestart == "yes") {
		# restore original request
		if (req.http.X-Orig-Host) {
			set req.http.Host = req.http.X-Orig-Host;
			unset req.http.X-Orig-Host;
		}

		if (req.http.X-Orig-URL) {
			set req.url = req.http.X-Orig-URL;
			unset req.http.X-Orig-URL;
		}

		return (restart);
	}
}

## moved to common/fake_age.vcl
#sub vcl_deliver {
#	if (resp.http.X-Ageless) {
#		# fake Age: header for objects where ttl > max-age
#		set resp.http.Age = "0";
#		unset resp.http.X-Ageless;
#	}
#}

## this would cache the first available object and not retry the update backend
## use this if you just want to locate files in multiple storage backends
## FIXME: that won't work with the cache_restart patch anymore,
## it would just hit the cached first response again
#sub vcl_hash {
#	if (req.http.X-Orig-URL) {
#		hash_data(req.http.X-Orig-URL);
#	} else {
#		hash_data(req.url);
#	}
#
#	if (req.http.X-Orig-Host) {
#		hash_data(req.http.X-Orig-Host);
#	} else if (req.http.Host) {
#		hash_data(req.http.Host);
#	} else {
#		hash_data(server.ip);
#	}
#
#	return (hash);
#}
