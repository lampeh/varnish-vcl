##
# rewrite the 403/405 page
#
# icon from http://austintheheller.deviantart.com/art/August-Iconset-62107634
##

# handle only 403/405 errors from VCL by default
# enable the following block to intercept 403/405 responses from backend, too
#sub vcl_fetch {
#	if (beresp.status == 403 || beresp.status == 405) {
#		error beresp.status beresp.response;
#	}
#}

sub vcl_error {
	if (obj.status == 403 || obj.status == 405) {
		set obj.http.Content-Type = "text/html; charset=utf-8";
		synthetic {"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="robots" content="noindex, nofollow" />
	<title>"} + obj.status + {" - Du kommst hier nicht rein</title>
	<style type="text/css">
		body { background: none no-repeat scroll 0 0 white; color: #222; padding-left: 10%; padding-top: 2em; font: 14px sans-serif; }
		#errorpage { width: 80%; height: auto !important; }
		.error_403 h2:before { vertical-align: top; content: url(data:image/png;base64,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) " "; }
	</style>
</head><body>
	<div id="errorpage" class="error_403">
		<h2>"} + obj.status + " - " + obj.response + {"</h2>
		<p>Sorry, your name is not on the guest list.</p>
		<p>Ask your project manager for the password.</p>
		<hr />
	</div>
</body></html>
"};
		return (deliver);
	}
}
