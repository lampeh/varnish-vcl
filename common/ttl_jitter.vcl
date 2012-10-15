##
# vary the TTL, so that objects don't expire all at the same time
#
# requires std vmod
##

# import std;

sub vcl_fetch {
	if (beresp.ttl > 0s) {
		set beresp.ttl = beresp.ttl * std.random(0.8, 1.0);
	}
}
