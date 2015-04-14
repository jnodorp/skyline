FROM debian:jessie
MAINTAINER Julian Schlichtholz <julian.schlichtholz@gmail.com>

# Install dependencies
RUN apt-get update && \
    apt-get install -y python3 \
                       python3-pip \
                       python3-numpy \
                       python3-scipy \
                       python3-pandas \
                       python3-nose \
                       python3-patsy \
                       python3-msgpack \
                       python3-redis \
                       python3-flask \
                       python3-simplejson \
                       python3-mock \
                       python3-pep8 && \
    rm -rf /var/lib/apt/lists/*

# Set python to python3
RUN rm -f /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python

# Install requirements.
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt && pip3 install pep8

# Add remaining sources
COPY . /data

# Set up working directory.
WORKDIR /data
RUN cp src/settings.py.example src/settings.py

# Run the tests.
RUN nosetests3 -v --nocapture
RUN python /usr/lib/python3/dist-packages/pep8.py --exclude=migrations --ignore=E501,E251,E265 ./

CMD ["bash"]