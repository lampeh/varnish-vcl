##
# return a default error page instead of Guru Meditation
#
# Note: must be the last included file defining sub vcl_error
#
# icon from http://austintheheller.deviantart.com/art/August-Iconset-62107634
##

sub vcl_error {
	# replace the default error page
	# don't use external style sheets, scripts or images here if they refer back 
	# to the varnish server. include images inline or use independent storage
	# images can be inlined with src="data:image/jpeg;base64,[base64 encoded string here]"

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
		.error_500 h2:before { vertical-align: top; content: url(data:image/png;base64,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) " "; }
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
	return (deliver);
}
