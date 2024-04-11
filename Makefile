dcn_prefix = runtime-debian-11-go1.20
package = mediawiki-page-publish
version = 0.0.1

help:
	@cat Makefile | grep '# `' | grep -v '@cat Makefile'

.PHONY: build-in-docker-func
build-in-docker-func:
	[ "${BUILD_ARCH}" != "" ] || ( echo "environment variable BUILD_ARCH is required" && exit 1 )
	docker exec ${dcn_prefix}-${BUILD_ARCH} rm -rf /src/build/
	docker exec ${dcn_prefix}-${BUILD_ARCH} mkdir -p /src/build/
	docker cp ./ ${dcn_prefix}-${BUILD_ARCH}:/src/build/${package}/
	docker exec ${dcn_prefix}-${BUILD_ARCH} chown -R root:root /src/build/
	docker exec --workdir /src/build/${package}/ ${dcn_prefix}-${BUILD_ARCH} make deb
	docker cp ${dcn_prefix}-${BUILD_ARCH}:/src/build/mediawiki-page-publish_${version}_${BUILD_ARCH}.deb \
		../mediawiki-page-publish_${version}_${BUILD_ARCH}.deb

# `make build-in-docker`           Build in docker
.PHONY: build-in-docker
build-in-docker:
	BUILD_ARCH=amd64 make build-in-docker-func
	BUILD_ARCH=arm64 make build-in-docker-func

# `make changelog`                 Update debian/changelog
.PHONY: changelog
changelog:
	bash changelog.sh

# `make deb`                       Build deb package
.PHONY: deb
deb:
	dpkg-buildpackage -us -uc

# `make clean`                     Clean
.PHONY: clean
clean:
	rm -rf ./deb/
	rm -rf ./debian/.debhelper/
	rm -rf ./debian/mediawiki-page-publish/
	rm -rf ./debian/files
	rm -rf ./debian/mediawiki-page-publish.debhelper.log
	rm -rf ./debian/mediawiki-page-publish.substvars
