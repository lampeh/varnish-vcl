##
# defines ACL httpsproxy
##

# these clients may set a HTTPS: header
acl httpsproxy {
	"127.0.0.1";
	"::1";
}
