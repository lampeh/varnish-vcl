##
# remove Google Analytics cookies from request
# these cookies are handled by javascript in the client browser
##

sub vcl_recv {
	if (req.http.Cookie) {
		# removes all cookies named __utm?? (utma, utmb... utmx, utmxx) - tracking thing
		set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *__utm..?=[^;]+;? *", "\1");

		if (req.http.Cookie == "") {
			unset req.http.Cookie;
		}
	}
}
