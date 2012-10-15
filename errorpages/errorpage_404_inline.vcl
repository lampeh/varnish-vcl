##
# rewrite the 404 page
#
# icon from http://austintheheller.deviantart.com/art/August-Iconset-62107634
##

# intercept 404 response from backend and send request into vcl_error()
sub vcl_fetch {
	if (beresp.status == 404) {
		error beresp.status beresp.response;
	}
}

sub vcl_error {
	if (obj.status == 404) {
		set obj.http.Content-Type = "text/html; charset=utf-8";
		synthetic {"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="robots" content="noindex, nofollow" />
	<title>404 - Das hamwa nich</title>
	<style type="text/css">
		body { background: none no-repeat scroll 0 0 white; color: #222; padding-left: 10%; padding-top: 2em; font: 14px sans-serif; }
		#errorpage { width: 80%; height: auto !important; }
		.error_404 h2:before { vertical-align: top; content: url(data:image/png;base64,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) " "; }
	</style>
</head><body>
	<div id="errorpage" class="error_404">
		<h2>"} + obj.status + " - " + obj.response + {"</h2>
		<p>Whatever you were looking for, it's not here anymore. Maybe it never was.</p>
		<p>If you think the webserver is wrong, please notify your project manager.</p>
		<hr />
	</div>
</body></html>
"};
		return (deliver);
	}
}
