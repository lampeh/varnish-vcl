##
# remove expire header from static files, add "public" to Cache-Control
##


sub vcl_fetch {
	if (req.url ~ "^[^?]*\.(png|jpg|gif|css|js|swf|flv|ico|xml|txt|pdf|doc|woff|eot|mp[34])(\?.*)?$"
		&& beresp.http.Cache-Control) {
			# use only Cache-Control: for static files
			remove beresp.http.Expires;

			# ensure "public" tag. backend should set "private" if necessary
			if (beresp.http.Cache-Control !~ "public" && beresp.http.Cache-Control !~ "private") {
				set beresp.http.Cache-Control = beresp.http.Cache-Control + ",public";
			}
	}
}
