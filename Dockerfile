ARG ARCH=armv7hf
ARG PKG=PyYAML

FROM balenalib/${ARCH}-debian-python:build as builder
ARG PKG
RUN [ "cross-build-start" ]
RUN pip3 install wheel \
    && pip3 wheel ${PKG} --wheel-dir=/tmp/build-${PKG}
RUN [ "cross-build-end" ]

FROM balenalib/${ARCH}-debian-python
ARG PKG
COPY --from=builder /tmp/build-${PKG} /tmp/build-${PKG}
RUN [ "cross-build-start" ]
RUN ls /tmp/build-${PKG}
RUN pip3 install --no-index --find-links=/tmp/build-${PKG} ${PKG} \
    && rm -rf /tmp/build-${PKG}
RUN useradd -m ${PKG}
RUN [ "cross-build-end" ]

USER ${PKG}

ENTRYPOINT [ "oci" ]
