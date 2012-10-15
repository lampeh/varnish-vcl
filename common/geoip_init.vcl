##
# obsolete! use libvmod-geoip: https://github.com/lampeh/libvmod-geoip
#
# Initialize GeoIP code
#
# defines function get_country_code()
# see http://drcarter.info/2010/07/another-way-to-link-varnish-and-maxmind-geoip/
#
# requires GeoIP library (on Debian install libgeoip-dev)
# add "-lGeoIP" to cc_command
##

C{
	#include <GeoIP.h>

	static GeoIP *gi = NULL;

	const char*
	get_country_code(const char* ip)
	{
		const char* country = NULL;

		if (!gi) {
			// The README says:
			// If GEOIP_MMAP_CACHE doesn't work on a 64bit machine, try adding
			// the flag "MAP_32BIT" to the mmap call.
			gi = GeoIP_new(GEOIP_MMAP_CACHE);
			//gi = GeoIP_new(GEOIP_STANDARD);
		}

		if (ip)
			country = GeoIP_country_code_by_addr(gi, ip);

		return country ? country : "Unknown";
	}
}C
