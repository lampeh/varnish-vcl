##
# return 302 or 301 redirect from VCL
# 
# Usage:
#  error 750 "https://www.example.com/";
# or
#  set req.http.location = "https://www.example.com" req.url;
#  error 750 req.http.location;
#
# Use error 751 for permanent redirect with code 301
##

sub vcl_error {
	# redirect from vcl. new location is in obj.response
	if (obj.status == 750 || obj.status == 751 ) {
		set obj.http.Location = obj.response;
		if (obj.status == 751) {
			set obj.status = 301;
			set obj.response = "Moved Permanently";
		} else {
			set obj.status = 302;
			set obj.response = "Moved Temporarily";
		}
		set obj.http.Content-Type = "text/html; charset=utf-8";
		unset obj.http.Retry-After;
		if (req.request != "HEAD") {
			synthetic {"<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>"} + obj.status + " - " + obj.response + {"</title>
</head>
<body>
	<div id="container">
		<h1>"} + obj.response + {"</h1>
		<p>The document has moved <a href=""} + obj.http.Location + {"">here</a>.</p>
	</div>
</body>
</html>"};
		}
		return(deliver);
	}
}
