##
# restart the request if the backend is unavailable
# or dies during the request
##

sub vcl_error {
	# restart request on status 503 (backend failure)
	if (obj.status == 503 && req.restarts < 4) {
		std.log("vcl_error(): Status 503 - restart");
		return (restart);
	}
}
