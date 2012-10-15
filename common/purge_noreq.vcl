##
# implement PURGE with regex in URL and Host: header
#
# purge without referencing req
# allows use of ban lurker
# see http://kly.no/posts/2010_07_28__Smart_bans_with_Varnish__.html
#
# requires ACL purge
##

sub vcl_fetch {
	set beresp.http.X-Purge-URL = req.url;
	set beresp.http.X-Purge-Host = req.http.host;
}

sub vcl_deliver {
	unset resp.http.X-Purge-URL;
	unset resp.http.X-Purge-Host;
}

sub vcl_recv {
	if (req.request == "PURGE") {
		if (!client.ip ~ purge) {
			error 405 "Not allowed.";
		}
		ban("obj.http.X-Purge-URL ~ " + req.url + " && obj.http.X-Purge-Host ~ " + req.http.host);
		error 200 "Added to ban list";
	}
}
