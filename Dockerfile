FROM ubuntu:15.04
MAINTAINER Julian Schlichtholz <julian.schlichtholz@gmail.com>

# Install dependencies.
RUN apt-get update \
 && apt-get install -y python \
                       python-numpy \
                       python-scipy \
                       python-pandas \
                       python-patsy \
                       python-msgpack \
                       python-redis \
                       python-flask \
                       python-simplejson \
                       python-mock \
                       python-daemon \
                       python-hiredis \
                       python-pip \
                       python-nose \
                       pep8 \
                       redis-server \
                       supervisor \
 && rm -rf /var/lib/apt/lists/*

# Add required directories.
RUN mkdir /var/run/skyline \
 && mkdir /var/log/skyline \
 && mkdir /var/dump

# Add sources.
COPY . /data

# Set up working directory.
WORKDIR /data
RUN pip install -r requirements.txt \
 && cp src/settings.py.example src/settings.py

# Adjust settings.
RUN sed -i "s/^\(daemonize .*\)$/# \1/" bin/redis.conf \
 && sed -i "4 i import os" src/settings.py \
 && sed -i "s/^WEBAPP_IP .*$/WEBAPP_IP = '0.0.0.0'/" src/settings.py \
 && sed -i "s/^GRAPHITE_HOST .*$/GRAPHITE_HOST = 'graphite'/" src/settings.py \
 && sed -i "s/^CARBON_PORT .*$/CARBON_PORT = os.getenv('GRAPHITE_PORT_2003_TCP_PORT', 2003)/" src/settings.py \
 && sed -i "s/^# HORIZON_IP .*$/HORIZON_IP = '0.0.0.0'/" src/settings.py

# Run the tests.
RUN nosetests -v --nocapture \
 && pep8 --exclude=migrations --ignore=E501,E251,E265 ./

# Expose port
EXPOSE 1500 2024 2025

CMD ["/usr/bin/supervisord","-c","/data/supervisord.conf"]
