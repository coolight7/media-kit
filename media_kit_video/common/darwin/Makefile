SPACE := $(subst ,, )
HEADERS_DESTDIR_ESCAPED=$(subst $(SPACE),\ ,${HEADERS_DESTDIR})

all: ${HEADERS_DESTDIR_ESCAPED}/mpv/*.h

MPV_HEADERS_VERSION=v0.40.0

TAR=tar
TAR_WILDCARDS_FLAG := $(shell ${TAR} --version 2>&1 | grep -q 'GNU' && echo "--wildcards" || echo "")

.cache/headers/mpv-${MPV_HEADERS_VERSION}.tar.gz:
	mkdir -p .cache/headers
	rm -f .cache/headers/*.tmp .cache/headers/*.tar.gz
	curl -L \
		https://github.com/mpv-player/mpv/archive/refs/tags/${MPV_HEADERS_VERSION}.tar.gz \
		-o .cache/headers/mpv.tar.gz.tmp
	mv .cache/headers/mpv.tar.gz.tmp .cache/headers/mpv-${MPV_HEADERS_VERSION}.tar.gz
	touch .cache/headers/mpv-${MPV_HEADERS_VERSION}.tar.gz

.cache/headers/mpv.tar.gz: .cache/headers/mpv-${MPV_HEADERS_VERSION}.tar.gz
	rm -f .cache/headers/mpv.tar.gz
	ln -s mpv-${MPV_HEADERS_VERSION}.tar.gz .cache/headers/mpv.tar.gz

${HEADERS_DESTDIR_ESCAPED}/mpv/*.h: .cache/headers/mpv.tar.gz
	mkdir -p ${HEADERS_DESTDIR_ESCAPED}/mpv
	${TAR} ${TAR_WILDCARDS_FLAG} -xvf .cache/headers/mpv.tar.gz --strip-components 2 -C ${HEADERS_DESTDIR_ESCAPED}/ 'mpv-*/include/mpv/'
	touch ${HEADERS_DESTDIR_ESCAPED}/mpv/*.h
