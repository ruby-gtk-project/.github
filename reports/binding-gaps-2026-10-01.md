# Binding gaps — 2026-10-01

## Summary

47 gaps across 53 ports, 35 of them with an issue and 12 blocking a single port each, 47 namespaces already covered by ruby-gnome, 28 ports needing nothing beyond what exists.

The top four gaps (Soup, Xdp, Json, XdpGtk4) unblock 38 of the 53 blocked ports between them.

The gap count is a floor because 81 names are unclassified.

## Ranked gaps

| Namespace | Ports blocked | Seen in | Issue |
|---|---|---|---|
| Soup | 22 | cargo, import, meson | filed |
| Xdp | 18 | cargo, import, meson | filed |
| Json | 11 | import, meson | filed |
| XdpGtk4 | 9 | import, meson | filed |
| Gly | 8 | cargo, import, meson | filed |
| GstPbutils | 7 | import, meson | filed |
| GlyGtk4 | 6 | import, meson | filed |
| Spelling | 6 | import, meson | filed |
| GWeather | 5 | import, meson | filed |
| Gee | 5 | meson | filed |
| GstPlay | 5 | cargo, import, meson | filed |
| Geoclue | 4 | import, meson | filed |
| GnomeDesktop | 4 | import, meson | filed |
| Goa | 4 | import, meson | filed |
| EDataServer | 3 | meson | filed |
| GTop | 3 | meson | filed |
| GeocodeGlib | 3 | import, meson | filed |
| GtkUnixPrint | 3 | meson | filed |
| Malcontent | 3 | meson | filed |
| UDisks | 3 | cargo, meson | filed |
| AppStream | 2 | meson | filed |
| Colord | 2 | meson | filed |
| Flatpak | 2 | meson | filed |
| GExiv2 | 2 | meson | filed |
| GUdev | 2 | meson | filed |
| Gcr | 2 | meson | filed |
| GstBadAudio | 2 | meson | filed |
| IBus | 2 | import, meson | filed |
| PackageKitGlib | 2 | meson | filed |
| Polkit | 2 | meson | filed |
| Shumate | 2 | import, meson | filed |
| Tracker | 2 | import, meson | filed |
| Tsparql | 2 | import, meson | filed |
| WebKitWebProcessExtension | 2 | meson | filed |
| Xmlb | 2 | meson | filed |
| CloudProviders | 1 | meson | — |
| Gck | 1 | meson | — |
| GnomeAutoar | 1 | meson | — |
| Grl | 1 | import, meson | — |
| Gspell | 1 | import | — |
| GstTag | 1 | meson | — |
| GstVideo | 1 | meson | — |
| MediaArt | 1 | import, meson | — |
| Notify | 1 | meson | — |
| Rest | 1 | import, meson | — |
| TelepathyGLib | 1 | import | — |
| UPowerGlib | 1 | import, meson | — |

## Since last week

New: none. Closed: none. Moved: none.

## Ports by what they are waiting on

| Port | Waiting on | Count |
|---|---|---|
| gnome-control-center-rb | Colord, GTop, GUdev, Gcr, GnomeDesktop, Goa, IBus, Json, Malcontent, Polkit, Soup, UDisks, UPowerGlib | 13 |
| nautilus-rb | CloudProviders, GExiv2, Gly, GlyGtk4, GnomeAutoar, GnomeDesktop, GstPbutils, GstTag, Tsparql, Xdp, XdpGtk4 | 11 |
| gnome-software-rb | AppStream, Flatpak, GUdev, GnomeDesktop, Json, Malcontent, PackageKitGlib, Polkit, Soup, Xmlb | 10 |
| gnome-maps-rb | GWeather, Geoclue, GeocodeGlib, Json, Rest, Shumate, Soup, Xdp | 8 |
| planify-rb | EDataServer, Gee, Goa, Json, Soup, Spelling, Xdp, XdpGtk4 | 8 |
| bazaar-rb | AppStream, Flatpak, Gly, GlyGtk4, Json, Malcontent, Soup, Xmlb | 8 |
| epiphany-rb | Gck, Gcr, GtkUnixPrint, Json, Soup, WebKitWebProcessExtension, XdpGtk4 | 7 |
| gnome-music-rb | Grl, GstPbutils, MediaArt, Soup, Tracker, Tsparql | 6 |
| gnome-contacts-rb | EDataServer, Gee, Gly, GlyGtk4, Goa, XdpGtk4 | 6 |
| gnome-weather-rb | GWeather, Geoclue, GeocodeGlib, Json, Soup | 5 |
| Tuba-rb | GExiv2, Gee, Json, Soup, Spelling | 5 |
| snapshot-rb | Gly, GlyGtk4, GstBadAudio, GstVideo, Xdp | 5 |
| Extension-Manager-rb | Gly, GlyGtk4, Json, Soup | 4 |
| Workbench-rb | Gly, Shumate, Xdp, XdpGtk4 | 4 |
| gnome-calendar-rb | EDataServer, GWeather, Geoclue, Soup | 4 |
| gnome-clocks-rb | GWeather, Geoclue, GeocodeGlib, GnomeDesktop | 4 |
| textpieces-rb | Gee, Json, Xdp, XdpGtk4 | 4 |
| forge-sparks-rb | Soup, Xdp, XdpGtk4 | 3 |
| Mousai-rb | GstPbutils, GstPlay, Soup | 3 |
| gnome-podcasts-rb | GstBadAudio, GstPbutils, GstPlay | 3 |
| loupe-rb | GWeather, Gly, Xdp | 3 |
| polari-rb | Soup, TelepathyGLib, Tracker | 3 |
| gnome-disk-utility-rb | Notify, UDisks | 2 |
| Solanum-rb | GstPbutils, GstPlay | 2 |
| decibels-rb | GstPbutils, GstPlay | 2 |
| showtime-rb | GstPbutils, GstPlay | 2 |
| Constrict-rb | Gly, GlyGtk4 | 2 |
| gnome-calculator-rb | Gee, Soup | 2 |
| papers-rb | GtkUnixPrint, Spelling | 2 |
| dialect-rb | Soup, Spelling | 2 |
| Commit-rb | Spelling, Xdp | 2 |
| Errands-rb | Goa, Xdp | 2 |
| Gradia-rb | Soup, Xdp | 2 |
| Impression-rb | UDisks, Xdp | 2 |
| Junction-rb | Xdp, XdpGtk4 | 2 |
| blanket-rb | Xdp, XdpGtk4 | 2 |
| simple-scan-rb | Colord, PackageKitGlib | 2 |
| yelp-rb | GtkUnixPrint, WebKitWebProcessExtension | 2 |
| gnome-characters-rb | IBus | 1 |
| gnome-text-editor-rb | Spelling | 1 |
| Switcheroo-rb | Xdp | 1 |
| Tangram-rb | Soup | 1 |
| Wike-rb | Soup | 1 |
| console-rb | GTop | 1 |
| eyedropper-rb | Xdp | 1 |
| frogr-rb | Json | 1 |
| gnome-system-monitor-rb | GTop | 1 |
| pika-backup-rb | Xdp | 1 |
| resources-rb | Soup | 1 |
| valuta-rb | Soup | 1 |
| webfont-kit-generator-rb | Soup | 1 |
| Apostrophe-rb | Gspell | 1 |
| Biblioteca-rb | Xdp | 1 |

28 port targets have no gaps at all.

## Not bindings

These are pure-Rust dependencies of the Rust upstreams; they need a Ruby equivalent rather than a gem, and no issue was opened. Common examples are gettext-rs, log, serde_json, async-channel, serde.

## Unclassified

| Name | Count |
|---|---|
| libecal-2.0 | 2 |

These are names `namespace-map.json` does not classify; 81 names are unclassified in all. Each one is either a missing gap or a name that should be marked as not a binding target, and until they are classified the numbers above are a floor.
