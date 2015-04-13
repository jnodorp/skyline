FROM debian:jessie
MAINTAINER Julian Schlichtholz <julian.schlichtholz@gmail.com>

# Install dependencies.
RUN apt-get update
RUN apt-get install -y python3
RUN apt-get install -y python3-pip
RUN apt-get install -y python3-numpy
RUN apt-get install -y python3-scipy
RUN apt-get install -y python3-pandas
RUN apt-get install -y python3-nose
RUN apt-get install -y python3-patsy
RUN apt-get install -y python3-msgpack
RUN apt-get install -y python3-redis
RUN apt-get install -y python3-flask
RUN apt-get install -y python3-simplejson
RUN apt-get install -y python3-mock
RUN apt-get install -y python3-pep8
RUN rm -rf /var/lib/apt/lists/*

# Set python to python3
RUN rm -f /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Add sources.
ADD . /data

# Set working directory.
WORKDIR /data

# Install requirements.
RUN pip3 install -r requirements.txt
RUN cp src/settings.py.example src/settings.py
RUN pip3 install pep8

# Run the tests.
RUN nosetests3 -v --nocapture
RUN pep8 --exclude=migrations --ignore=E501,E251,E265 ./

CMD ["bash"]