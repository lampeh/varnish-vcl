##
# GeoIP lookup
#
# Sets X-Country-Code: to the country code associated with the client IP address
# Sets X-Country-Code-IP: to the IP addressed used for the lookup
#
# TODO: Skip addresses of trusted proxies in X-Forwarded-For:
#       VCL has if tests, but no loops.
#       Workaround: don't add client.ip to xff in vcl_recv if known proxy detected
#
# requires libvmod-geoip - https://github.com/lampeh/libvmod-geoip
##

# import geoip;

sub vcl_recv {
	unset req.http.X-Country-Code;
	unset req.http.X-Country-Code-IP;

	# use first address from X-Forwarded-For: if the request comes from a trusted client.ip
	if (client.ip ~ httpsproxy && req.http.X-Forwarded-For) {
		set req.http.X-Country-Code-IP = regsub(req.http.X-Forwarded-For, "(?i)(^|.*,) *([0-9a-f.:]+)$", "\2");
	} else {
		set req.http.X-Country-Code-IP = client.ip;
	}
	set req.http.X-Country-Code = geoip.country_code(req.http.X-Country-Code-IP);
}
