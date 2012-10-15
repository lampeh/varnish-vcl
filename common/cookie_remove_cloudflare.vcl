##
# remove Cloudflare cookies from request
# these cookies are used by the Cloudflare proxy
# see http://www.cloudflare.com/
##

sub vcl_recv {
	if (req.http.Cookie) {
        set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *__cfduid=[^;]+;? *", "\1");
        set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *cf_use_ob=[^;]+;? *", "\1");

		if (req.http.Cookie == "") {
			unset req.http.Cookie;
		}
	}
}
