# rsync front-end:

$ gulp build
$ rsync --exclude=data --exclude=index.html --compress --archive --verbose --checksum --delete --chmod=a+r dist/ gijsjb@hi7.huygens.knaw.nl:/data/htdocs/cdn/elaborate/publication/collection/development

## TODO

- Cache the NavBar so it doesn't have to reload the thumbnails.

## Changelog

#### v1.1.0

- [perf] Change thumbnail loading logic so it only loads the visible thumbnails.
- [bug] Hide site menu when printing.
- [feat] Update to latest faceted search.


