##
# force a cache miss if the client sets an "X-FreshForce: yes" header
## 

sub vcl_recv {
	if (req.http.X-FreshForce == "yes") {
		# Force a cache miss
		set req.hash_always_miss = true;
	}
}
