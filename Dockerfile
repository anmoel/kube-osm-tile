FROM ubuntu:xenial
MAINTAINER André Möller <moeller@mecom.de>

RUN apt-get update && \
    apt-get install -y git supervisor libboost-all-dev git-core tar unzip wget bzip2 build-essential autoconf \
    libtool libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev \
    munin-node munin libprotobuf-c0-dev protobuf-c-compiler libfreetype6-dev libpng12-dev \
    libtiff5-dev libicu-dev libgdal-dev libcairo-dev libcairomm-1.0-dev apache2 apache2-dev \
    libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev libgeotiff-epsg libgdal1-dev \
    libmapnik-dev mapnik-utils python-mapnik npm nodejs-legacy fonts-noto-cjk fonts-noto-hinted \
    fonts-noto-unhinted ttf-unifont && \
    mkdir /src && cd /src && git clone git://github.com/SomeoneElseOSM/mod_tile.git && \
    cd mod_tile && ./autogen.sh && ./configure && make && \
    make install && make install-mod_tile && ldconfig && a2enconf mod_tile && \
    cd /src && \
    git clone git://github.com/gravitystorm/openstreetmap-carto.git && \
    cd openstreetmap-carto && npm install -g carto && \
    scripts/get-shapefiles.py -s && carto project.mml > mapnik.xml && \
    mkdir /var/lib/mod_tile && \
    mkdir /var/run/renderd

ADD renderd.conf /usr/local/etc/renderd.conf
ADD mod_tile.conf /etc/apache2/conf-available/mod_tile.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV PGHOST=pgset \
    PGPORT=5432 \
    PGUSER=osm \
    PGPASSWORD=password

EXPOSE 8080
CMD ["/usr/bin/supervisord"]
