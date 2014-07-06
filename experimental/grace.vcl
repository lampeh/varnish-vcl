##
# serve slightly stale objects if the backend is busy or sick
##

## TODO: update grace handling
## Varnish 4.x moved grace logic to vcl_hit
## see https://www.varnish-cache.org/docs/trunk/users-guide/vcl-grace.html

#sub vcl_recv {
#	# if requests for the same object pile up,
#	# serve expired cacheable objects for 30s
#	if (std.healthy(req.backend_hint)) {
#		set req.grace = 30s;
#	} else {
#		# if the backend is down,
#		# serve expired cacheable objects for 1h
#		# requires backend probes
#		set req.grace = 1h;
#	}
#}

sub vcl_backend_response {
	# keep old objects in cache for 1h after expiry
	set beresp.grace = 1h;
}
