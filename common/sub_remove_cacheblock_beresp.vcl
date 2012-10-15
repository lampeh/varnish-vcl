##
#
# remove cache-blocking headers from backend response
#
##

sub remove_cacheblock_beresp {
	unset beresp.http.Set-Cookie;
	unset beresp.http.Cache-Control;
	unset beresp.http.Pragma;
	unset beresp.http.Expires;
	unset beresp.http.Last-Modified;
}
