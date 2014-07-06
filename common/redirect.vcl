##
# return 302 or 301 redirect from VCL
# 
# Usage:
#  return(synth(750, "https://www.example.com/"));
# or
#  set req.http.location = "https://www.example.com" req.url;
#  error 750 req.http.location;
#
# Use error 751 for permanent redirect with code 301
##

sub vcl_synth {
	# redirect from vcl. new location is in resp.reason
	if (resp.status == 750 || resp.status == 751 ) {
		set resp.http.Location = resp.reason;
		if (resp.status == 751) {
			set resp.status = 301;
			set resp.reason = "Moved Permanently";
		} else {
			set resp.status = 302;
			set resp.reason = "Moved Temporarily";
		}
		set resp.http.Content-Type = "text/html; charset=utf-8";
		unset resp.http.Retry-After;
		if (req.method != "HEAD") {
			synthetic({"<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>"} + resp.status + " - " + resp.reason + {"</title>
</head>
<body>
	<div id="container">
		<h1>"} + resp.reason + {"</h1>
		<p>The document has moved <a href=""} + resp.http.Location + {"">here</a>.</p>
	</div>
</body>
</html>"});
		}
		return(deliver);
	}
}
