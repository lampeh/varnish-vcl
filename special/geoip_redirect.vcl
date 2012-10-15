##
# obsolete! use libvmod-geoip: https://github.com/lampeh/libvmod-geoip
#
# Simple GeoIP redirect
#
# redirect foo.example.com to
# foo.example.at for country code AT
# foo.example.de for everyone else
#
# requires country code in X-Country-Code: header
# either include common/geoip_lookup.vcl or
# enable lookup code below
##

sub vcl_recv {
	if (req.http.host ~ "(?i).*\.example\.com$") {

		# if you want GeoIP resolution only for this redirect,
		# include common/geoip_init.vcl and enable this block
		#unset req.http.X-Country-Code;
		#C{
		#	VRT_SetHdr(sp, HDR_REQ, "\017X-Country-Code:", (*get_country_code)( VRT_IP_string(sp, VRT_r_client_ip(sp)) ), vrt_magic_string_end);
		#}C
		#log "X-Country-Code: " req.http.X-Country-Code;

		# if "HTTPS: on" header is set, redirect to https://
		if (req.http.https == "on") {
			set req.http.x-proto = "https";
		} else {
			set req.http.x-proto = "http";
		}

		if (req.http.X-Country-Code == "AT") {
			set req.http.location = req.http.x-proto "://" regsub(req.http.host, "(?i)(.*)\.example\.com$", "\1.example.at") req.url;
		} else {
			set req.http.location = req.http.x-proto "://" regsub(req.http.host, "(?i)(.*)\.example\.com$", "\1.example.de") req.url;
		}

		unset req.http.x-proto;
		error 750 req.http.location;
	}
}
