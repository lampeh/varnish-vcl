##
# shortcut for DFind requests
##

sub vcl_recv {
	if (req.url ~ "^/w00tw00t") {
		error 404 "Not Found";
	}
}
