##
# return a default error page instead of Guru Meditation
#
# Note: must be the last included file defining sub vcl_error
#
# icon from http://austintheheller.deviantart.com/art/August-Iconset-62107634
# ( http://www.iconfinder.com/search/?q=iconset%3Aaugust )
##

sub vcl_error {
	# replace the default error page
	# don't use external style sheets, scripts or images here if they refer back
	# to the varnish server. include images inline or use independent storage
	# images can be inlined with src="data:image/jpeg;base64,[base64 encoded string here]"

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
	<title>"} + obj.status + " - " + obj.response + {"</title>
	<style type="text/css">
		body { background: none no-repeat scroll 0 0 white; color: #222; padding-left: 10%; padding-top: 2em; font: 14px sans-serif; }
		#errorpage { width: 80%; height: auto !important; }
		.error_500 h2:before { vertical-align: top; content: url("} + obj.http.x-proto + {"://smag-misc.s3.amazonaws.com/smallicons/smiley_angry_small.png) " "; }
	</style>
</head><body>
	<div id="errorpage" class="error_500">
		<h2>Narf!</h2>
		<p>Something went wrong with your request. Please try again.<br />
		If you still see this message, please contact your project manager.</p>
		<p>To put it more technically:<br /><em>"} + obj.status + " - " + obj.response + {"</em></p>
		<hr />
	</div>
</body></html>
"};

	# remove temporary header
	unset obj.http.x-proto;

	return (deliver);
}
