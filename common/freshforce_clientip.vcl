##
# force a cache miss if the client address matches the freshforce acl
#
# requires ACL freshforce
##

sub vcl_recv {
	if (client.ip ~ freshforce) {
		# Force a cache miss
		set req.hash_always_miss = true;
		set req.http.X-FreshForce = "yes";
	}
}
