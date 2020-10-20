FROM balenalib/armv7hf-debian-python:build as builder

RUN [ "cross-build-start" ]
RUN pip3 install wheel \
    && pip3 wheel oci-cli --wheel-dir=/tmp/build-oci-cli
RUN [ "cross-build-end" ]


FROM balenalib/armv7hf-debian-python

COPY --from=builder /tmp/build-oci-cli /tmp/build-oci-cli

RUN [ "cross-build-start" ]
RUN pip3 install --no-index --find-links=/tmp/build-oci-cli/wheels oci-cli \
    && rm -rf /tmp/build-oci-cli
RUN useradd -m oci
RUN [ "cross-build-end" ]

USER oci

ENTRYPOINT [ "oci" ]
