##
# redirect requests for *.pool.ntp.org to www.pool.ntp.org
# 
# - requires common/redirect.vcl
##

sub vcl_recv {
	if (req.http.Host ~ "(?i)\.?pool\.ntp\.org$") {
		error 751 "http://www.pool.ntp.org/";
	}
}
