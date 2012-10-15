sub vcl_fetch {
	# set low TTL for munin graphs
	# TODO: this should be set by Apache
	if (req.url ~ "^/munin[-/]") {
		set beresp.ttl = 60s;
	}
}
