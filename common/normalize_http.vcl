##
# - repair weird request format "GET http://host/path"
# - normalize Accept-Encoding header: gzip or none
##

sub vcl_recv {
	# fix "GET http://host/path" request
	# extract Host: header and rewrite URL
	if (req.url ~ "(?i)^https?://") {
		set req.http.Host = regsub(req.url, "(?i)^https?://([^/]*).*", "\1");
		set req.url = regsub(req.url, "(?i)^https?://[^/]*/?(.*)$", "/\1");
	}

# TODO: remove port number from Host: header without hurting IPv6 addresses
#	if (req.http.host ~ "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+") {
#		set req.http.Host = regsub(req.http.Host, "([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):[0-9]+", "\1");
#	} elsif req.http.host ~ "(\[[\]]+):[0-9]+") {
#		set req.http.Host = regsub(req.http.Host, "(\[[\]]+):[0-9]+", "\1");
#	}

	# normalize Accept-Encoding to either gzip or nothing
	# 3.x: already handled by http_gzip_support=on
}
