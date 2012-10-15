##
# If you find that the response is not appropriate you can set beresp.saintmode to a time limit and call restart. Varnish 
# will then retry other backends to try to fetch the object again.
#
# If there are no more backends or if you hit max_restarts and we have an object that is younger than what you set 
# beresp.saintmode to be Varnish will serve the object, even if it is stale.
##

sub vcl_fetch {
	if (beresp.status == 500 && req.restarts < 4) {
		std.log("vcl_fetch(): Status 500 - restart with saintmode");
		# blacklist this backend/object combination for 60s,
		# use alternative backends if possible
		set beresp.saintmode = 60s;
		return (restart);
    }
}
