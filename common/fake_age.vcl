##
# fake Age: header for objects where ttl > max-age
#
# set beresp.http.X-Ageless in vcl_backend_response
##

sub vcl_deliver {
	if (resp.http.X-Ageless) {
		# fake Age: header for objects where ttl > max-age
		set resp.http.Age = "0";
		unset resp.http.X-Ageless;
	}
}
