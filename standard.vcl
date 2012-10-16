##
# varnish configuration
##

## built-in standard library - https://www.varnish-cache.org/docs/trunk/reference/vmod_std.html
import std;

## GeoIP lookup functions - https://github.com/lampeh/libvmod-geoip
#import geoip;

## header-modification vmod - https://github.com/varnish/libvmod-header
#import header;

## digest and HMAC vmod - https://github.com/varnish/libvmod-digest
#import digest;

## cURL bindings for Varnish - https://github.com/varnish/libvmod-curl
#import curl;

## variable support vmod - https://github.com/varnish/libvmod-var
#import var;


## all paths relative to varnish option vcl_dir defined in /etc/default/varnish 


## edit node configuration in config/*
## backends
include "config/backend.vcl";
## ACLs
include "config/acl_httpsproxy.vcl";
#include "config/acl_extcache.vcl";
#include "config/acl_freshforce.vcl";
include "config/acl_purge.vcl";


## helper functions

## remove cache-blocking headers from backend response
#include "common/sub_remove_cacheblock_beresp.vcl";


## common snippets

## PURGE requests
## for ban lurker support, use purge_noreq instead of purge.vcl
#include "common/purge.vcl";
include "common/purge_noreq.vcl";

## reject /w00tw00t requests
include "common/no_w00t.vcl";

## force a cache miss if the client sets an "X-FreshForce: yes" header
include "common/freshforce_header.vcl";

## force a cache miss if the client address matches the freshforce acl
#include "common/freshforce_clientip.vcl";

## force a cache miss if the user agent matches "Googlebot"
#include "common/freshforce_googlebot.vcl";

## add "Connection: close" to piped requests
include "common/pipe_close.vcl";

## return 302 or 301 redirect from VCL
include "common/redirect.vcl";

## restart the request on backend error
include "common/error_restart.vcl";

## repair weird request format "GET http://host/path"
include "common/normalize_http.vcl";

## allow "HTTPS:" header from SSL proxies only
include "common/http_https.vcl";

## avoid stall if a request loops back from another cache
#include "common/extcache_ignorebusy.vcl";

## fake Age: header for objects where ttl > max-age
include "common/fake_age.vcl";

## remove cookies from requests for static files
include "common/cookie_remove_static.vcl";

## remove Google Analytics cookies from request
include "common/cookie_remove_ga.vcl";

## remove Cloudflare cookies from request
#include "common/cookie_remove_cloudflare.vcl";

## remove expires header from static files, add "public" to Cache-Control
include "common/expire_remove_static.vcl";

## advertise ESI, handle ESI responses
include "common/esi.vcl";

## set object TTL from Cache-Control: v-maxage attribute
include "common/ttl_v-maxage.vcl";

## vary TTL to avoid clustering of expired objects
include "common/ttl_jitter.vcl";

## GeoIP lookup: add X-Country-Code to request header
#include "common/geoip_lookup.vcl";

## grace and saintmode
include "experimental/grace.vcl";
include "experimental/saintmode.vcl";


## custom code here

sub vcl_recv {
	# redirect admin vhost to HTTPS
	# Apache rewrite cannot do this because "Vary: HTTPS" is lost on redirect
	# would cause endless redirect loop
	if (req.http.Host ~ "(?i)^admin\." && req.http.https != "on") {
		set req.http.Location = "https://" + req.http.Host + req.url;
		error 751 req.http.Location;
	}
        
#	## forward static.* vhosts to nginx
#	if (req.http.Host ~ "(?i)^static(-origin)?\.") {
#		set req.backend = static;
#	} else {
#		set req.backend = default;
#	}
}


## custom error pages to replace Guru Meditation
include "errorpages/errorpage_200.vcl";
#include "errorpages/errorpage_403.vcl";
#include "errorpages/errorpage_404.vcl";
## default errorpage must come last in vcl_error()
#include "errorpages/errorpage_default.vcl";
## don't include errorpages/ beyond this point


##


# Below is a copy of the default VCL logic. If you redefine any of these
# subroutines, the built-in logic will be appended to your code.

sub vcl_recv {
    if (req.restarts == 0) {
	if (req.http.x-forwarded-for) {
	    set req.http.X-Forwarded-For =
		req.http.X-Forwarded-For + ", " + client.ip;
	} else {
	    set req.http.X-Forwarded-For = client.ip;
	}
    }
    if (req.request != "GET" &&
      req.request != "HEAD" &&
      req.request != "PUT" &&
      req.request != "POST" &&
      req.request != "TRACE" &&
      req.request != "OPTIONS" &&
      req.request != "DELETE") {
        /* Non-RFC2616 or CONNECT which is weird. */
        return (pipe);
    }
    if (req.request != "GET" && req.request != "HEAD") {
        /* We only deal with GET and HEAD by default */
        return (pass);
    }
    if (req.http.Authorization || req.http.Cookie) {
        /* Not cacheable by default */
        return (pass);
    }
    return (lookup);
}

sub vcl_pipe {
    # Note that only the first request to the backend will have
    # X-Forwarded-For set.  If you use X-Forwarded-For and want to
    # have it set for all requests, make sure to have:
    # set bereq.http.connection = "close";
    # here.  It is not set by default as it might break some broken web
    # applications, like IIS with NTLM authentication.
    return (pipe);
}

sub vcl_pass {
    return (pass);
}

sub vcl_hash {
    hash_data(req.url);
    if (req.http.host) {
        hash_data(req.http.host);
    } else {
        hash_data(server.ip);
    }
    return (hash);
}

sub vcl_hit {
    return (deliver);
}

sub vcl_miss {
    return (fetch);
}

sub vcl_fetch {
    if (beresp.ttl <= 0s ||
        beresp.http.Set-Cookie ||
        beresp.http.Vary == "*") {
		/*
		 * Mark as "Hit-For-Pass" for the next 2 minutes
		 */
		set beresp.ttl = 120 s;
		return (hit_for_pass);
    }
    return (deliver);
}

sub vcl_deliver {
    return (deliver);
}

sub vcl_error {
    set obj.http.Content-Type = "text/html; charset=utf-8";
    set obj.http.Retry-After = "5";
    synthetic {"
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
  <head>
    <title>"} + obj.status + " " + obj.response + {"</title>
  </head>
  <body>
    <h1>Error "} + obj.status + " " + obj.response + {"</h1>
    <p>"} + obj.response + {"</p>
    <h3>Guru Meditation:</h3>
    <p>XID: "} + req.xid + {"</p>
    <hr>
    <p>Varnish cache server</p>
  </body>
</html>
"};
    return (deliver);
}

sub vcl_init {
	return (ok);
}

sub vcl_fini {
	return (ok);
}
