##
# allow "HTTPS:" header from SSL proxies only
#
# requires ACL httpsproxy
##

sub vcl_recv {
	# remove HTTPS: header if request is not from local SSL proxy
	if (!client.ip ~ httpsproxy) {
		unset req.http.https;
	}
}
