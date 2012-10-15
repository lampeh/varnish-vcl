##
# avoid race condition if a request loops back from another cache
#
# requires ACL extcache
##

sub vcl_recv {
	if (client.ip ~ extcache) {
		# Request is coming from the other server.
		# Ignore busy objects to avoid race condition.
		set req.hash_ignore_busy = true;
	}
}
