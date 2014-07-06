##
# implement PURGE with regex in URL and Host: header
#
# requires ACL purge
##

sub vcl_recv {
	if (req.method == "PURGE") {
		if (!client.ip ~ purge) {
			return(synth(405, "Not allowed."));
		}
		ban("req.url ~ " + req.url + " && req.http.host ~ " + req.http.host);
		return(synth(200, "Added to ban list"));
	}
}
