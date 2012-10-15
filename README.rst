===========
varnish-vcl
===========

Collection of VCL code


config
------
Node-specific ACLs and backend definitions.

acl_extcache.vcl
  sibling cache source addresses

acl_freshforce.vcl
  client addresses forcing a cache miss

acl_httpsproxy.vcl
  clients allowed to set HTTPS header

acl_purge.vcl
  clients allowed to issue PURGE requests

backend.vcl
  backend definitions


common
------
Useful VCL snippets for most occasions.

cookie_remove_static.vcl
  remove cookies from static file requests

cookie_remove_ga.vcl
  remove Google Analytics javascript cookies

cookie_remove_cloudflare.vcl
  remove Cloudflare cookies from request

error_restart.vcl
  restart request on error 503 (backend unavailable)

extcache_ignorebusy.vcl
  ignore busy objects to avoid race condition in cache networks

fake_age.vcl
  reset Age: header (useful if varnish should cache an object longer than the browser)

freshforce_clientip.vcl
  force cache miss by client IP address

freshforce_header.vcl
  force cache miss by X-FreshForce request header

freshforce_googlebot.vcl
  force cache miss by Googlebot user-agent

http_https.vcl
  allow HTTPS: header from whitelisted SSL proxies only

normalize_http.vcl
  normalize HTTP request variants

pipe_close.vcl
  add Connection: close header to piped requests

purge_noreq.vcl
  implement PURGE with regex in URL and Host: header, with ban-lurker support

purge.vcl
  implement PURGE with regex in URL and Host: header

redirect.vcl
  return 301/302 redirect from VCL

ttl_jitter.vcl
  vary object TTL to spread out cache refresh

geoip_init.vcl
  initialize inline-C GeoIP code - **obsolete!** use libvmod-geoip instead

geoip_lookup.vcl
  add X-Country-Code: header to request

no_w00t.vcl
  404 shortcut for DFind requests

sub_remove_cacheblock_beresp.vcl
  remove cache-blocking headers from backend response


errorpages
----------
Replace the default Guru Meditation. Icons either inlined or included from Amazon S3.


special
-------
Site-specific VCL.


experimental
------------
VCL experiments. Could fail unexpectedly.
