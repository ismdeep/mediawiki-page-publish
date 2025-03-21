help:

.PHONY: deb
deb:
	dpkg-buildpackage -us -uc

.PHONY: changelog
changelog:
	bash changelog.sh

.PHONY: clean
clean:
	rm -rf ./deb/
	rm -rf ./debian/.debhelper/
	rm -rf ./debian/mediawiki-page-publish/
	rm -rf ./debian/files
	rm -rf ./debian/mediawiki-page-publish.debhelper.log
	rm -rf ./debian/mediawiki-page-publish.substvars
