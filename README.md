# rsync front-end:

$ gulp build
$ rsync --exclude=data --exclude=index.html --compress --archive --verbose --checksum --delete --chmod=a+r dist/ gijsjb@hi7.huygens.knaw.nl:/data/htdocs/cdn/elaborate/publication/collection/development