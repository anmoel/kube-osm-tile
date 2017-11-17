FROM ubuntu:xenial
MAINTAINER André Möller <moeller@mecom.de>

RUN apt-get update && \
    apt-get install -y git libboost-all-dev git-core tar unzip wget bzip2 build-essential autoconf \
    libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev \
    munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev \
    libtiff5-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev \
    libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg libgdal1-dev \
    libmapnik-dev mapnik-utils python-mapnik npm nodejs-legacy fonts-noto-cjk fonts-noto-hinted \
    fonts-noto-unhinted ttf-unifont && \
    mkdir ~/src && cd ~/src && git clone git://github.com/SomeoneElseOSM/mod_tile.git && \
    cd mod_tile && ./autogen.sh && ./configure && make && \
    make install && make install-mod_tile && ldconfig && \
