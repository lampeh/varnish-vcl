##
# implement PURGE with regex in URL and Host: header
#
# requires ACL purge
##

sub vcl_recv {
	if (req.request == "PURGE") {
		if (!client.ip ~ purge) {
			error 405 "Not allowed.";
		}
		ban("req.url ~ " + req.url + " && req.http.host ~ " + req.http.host);
		error 200 "Added to ban list";
	}
}
