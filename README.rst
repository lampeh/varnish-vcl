===========
varnish-vcl
===========

Collection of VCL code

`Wiki documentation <https://github.com/lampeh/varnish-vcl/wiki>`_


standard.vcl
  configuration root. copy or symlink to default.vcl


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

backend_default.vcl
  default backend definition

cookie_remove_static.vcl
  remove cookies from static file requests

cookie_remove_ga.vcl
  remove Google Analytics javascript cookies

cookie_remove_cloudflare.vcl
  remove Cloudflare cookies from request

error_restart.vcl
  restart request on error 503 (backend unavailable)

extcache_ignorebusy.vcl
  ignore busy objects to avoid stall in cache meshes

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

ttl_v-maxage.vcl
  set object TTL from Cache-Control: v-maxage attribute

geoip_lookup.vcl
  add X-Country-Code: header to request. requires `libvmod-geoip <https://github.com/lampeh/libvmod-geoip>`_

no_w00t.vcl
  404 shortcut for DFind requests

sub_remove_cacheblock_beresp.vcl
  remove cache-blocking headers from backend response


errorpages
----------
Replace the default Guru Meditation. Icons either inlined or included from Amazon S3.

errorpage_200_inline.vcl
  varnish message page, with inline icon

errorpage_200.vcl
  varnish message page, with external icon

errorpage_404_inline.vcl
  404 page, with inline icon

errorpage_404.vcl
  404 page, with external icon

errorpage_403_inline.vcl
  403 page, with inline icon

errorpage_403.vcl
  403 page, with external icon

errorpage_default_inline.vcl
  default error page, with inline icon

errorpage_default.vcl
  default error page, with external icon


experimental
------------
VCL experiments and/or untested functions. Could fail unexpectedly.

grace.vcl
  set grace time

saintmode.vcl
  set saint mode on error 500


special
-------
Site-specific VCL.

munin_ttl.vcl
  low TTL for munin graphs

redirect_pool.ntp.org.vcl
  redirect \*.pool.ntp.org to www.pool.ntp.org

backend_select_updates.vcl
  Hierarchical Backend Selection:
  Locate the requested file on alternative backends and cache them if found.
  Requires `cached restart patch <https://www.varnish-cache.org/trac/ticket/412>`_ to work with varnish 2.x.
  Not tested with varnish 3.x.
