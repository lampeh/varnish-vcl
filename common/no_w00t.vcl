##
# shortcut for DFind requests
##

sub vcl_recv {
	if (req.url ~ "^/w00tw00t") {
		return(synth(404, "Not Found"));
	}
}
