##
# set TTL from Cache-Control: v-maxage attribute
#
# removes v-maxage from header
# sets X-Ageless flag
##

sub vcl_fetch {
	if (beresp.http.Cache-Control ~ "(^|,) *v-maxage=") {
#		set req.http.X-Orig-TTL = beresp.ttl;
		set beresp.ttl = std.duration(regsub(beresp.http.Cache-Control, "(^|.*,) *v-maxage=([0-9]*) *(,.*|$)", "\2s"), 0s);
		set beresp.http.Cache-Control = regsub(beresp.http.Cache-Control, "(^|,) *v-maxage=[0-9]* *(, *|$)", "\1");
#		if (beresp.ttl > std.duration(req.http.X-Orig-TTL + "s", 0s)) {
			set beresp.http.X-Ageless = "yes";
#		}
	}
}
