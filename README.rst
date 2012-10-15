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
Useful VCL snippets for all occasions.


errorpages
----------
Replace the default Guru Meditation. Icons either inlined or included from Amazon S3.


special
-------
Site-specific VCL.


experimental
------------
VCL experiments. Could fail unexpectedly.
