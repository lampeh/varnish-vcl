##
# add "Connection: close" to piped requests
##

sub vcl_pipe {
	# Note that only the first request to the backend will have
	# X-Forwarded-For set.  If you use X-Forwarded-For and want to
	# have it set for all requests, make sure to have:
	# set bereq.http.connection = "close";
	# here.  It is not set by default as it might break some broken web
	# applications, like IIS with NTLM authentication. 

	set bereq.http.connection = "close";
}
