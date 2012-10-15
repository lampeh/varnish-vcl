##
# remove cookies from requests for static files
##

sub vcl_recv {
	if (req.url ~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
		unset req.http.cookie;
	}
}

sub vcl_fetch {
	## TODO: is this necessary? the backend should not set cookies on static files
	if (req.url ~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$") {
		unset beresp.http.set-cookie;
	}
}
