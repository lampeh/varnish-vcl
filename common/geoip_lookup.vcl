##
# obsolete! use libvmod-geoip: https://github.com/lampeh/libvmod-geoip
#
# GeoIP lookup
#
# adds X-Country-Code: header to HTTP request
# see http://drcarter.info/2010/07/another-way-to-link-varnish-and-maxmind-geoip/
#
# TODO: Extract address from X-Forwarded-For: header if client.ip is a trusted proxy
#
# requires common/geoip_init.vcl
##

sub vcl_recv {
	# determine country code, set X-Country-Code: header
	unset req.http.X-Country-Code;
	C{
		VRT_SetHdr(sp, HDR_REQ, "\017X-Country-Code:", (*get_country_code)( VRT_IP_string(sp, VRT_r_client_ip(sp)) ), vrt_magic_string_end);
	}C
	#log "X-Country-Code: " req.http.X-Country-Code;
}
