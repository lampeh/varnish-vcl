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

		# save request protocol to object header for later reference in the HTML code
		if (req.http.https == "on") {
			set obj.http.x-proto = "https";
		} else {
			set obj.http.x-proto = "http";
		}

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
		.error_403 h2:before { vertical-align: top; content: url("} + obj.http.x-proto + {"://smag-misc.s3.amazonaws.com/smallicons/smiley_cool_small.png) " "; }
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

		# remove temporary header
		unset obj.http.x-proto;

		return (deliver);
	}
}
