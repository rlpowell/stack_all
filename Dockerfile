FROM rlpowell/shell

USER root
COPY stack.repo /etc/yum.repos.d/stack.repo
RUN dnf install -y stack

# All the freaking libraries the various things need
RUN dnf install -y DevIL-devel cairo-devel expat-devel file-devel \
fontconfig-devel gcc-c++ gd-devel ghc-pcap gnutls-devel \
gobject-introspection-devel gtk+-devel gtk2-devel gtk3-devel \
leveldb-devel libbsd-devel libgsasl-devel libmarkdown-devel \
libnotify-devel libpcap-devel libpng-devel libxml2-devel mysql-devel \
pango-devel postgresql-devel readline-devel sqlite-devel \
taglib-devel alsa-lib-devel mesa-libGLU-devel libfreenect-devel \
gtksourceview3-devel GeoIP-devel libsndfile-devel hidapi-devel \
SDL2-devel fftw-devel blas64-devel lapack64-devel gsl-devel \
webkitgtk3-devel zeromq-devel

USER rlpowell
RUN mkdir /home/rlpowell/stack
COPY stack.yaml stack_all_internal.sh stack.hs stack.cabal /home/rlpowell/stack/
