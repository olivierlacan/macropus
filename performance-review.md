# Performance Review

Importantly those timings are straight from Charles Proxy which I set up as a
debugging proxy from my iOS device's networking settings, not something I
manually timed.

They include the full request so there's probably quite a bit
of network latency that's hard to factor out, although all these come from
an iOS device on a home Wi-Fi network with fairly low latency
(per speed.cloudflare.com) at 17.7ms with 2.40ms jitter. 269 Mbps down and
34.9 Mbps up as well.

| query | max duration |
| --- | --- |
| `searchPlaces` | 5.05s |
| `fetchTagsByRelatedTagId` | 1.24s |
| `searchTags` | 923ms |
| `searchPlacesWithAddressDetail` | 703ms |
| `fetchTagsByType` | 671 ms |
| `fetchPlaceById` | 668ms |
| `updatePlace` | 170ms |
