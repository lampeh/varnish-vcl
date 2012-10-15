##
# force a cache miss if the user agent matches "Googlebot"
##

sub vcl_recv {
	if (req.http.user-agent ~ "Googlebot") {
		# Force a cache miss
		set req.hash_always_miss = true;
	}
}
