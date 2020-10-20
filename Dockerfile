FROM balenalib/armv7hf-debian-python

RUN [ "cross-build-start" ]

RUN pip3 install oci-cli
RUN useradd -m oci

RUN [ "cross-build-end" ]

USER oci

ENTRYPOINT [ "oci" ]
