ARG ARCH=armv7hf
ARG PYTHON_VERSION=3.8
ARG PKG=oci-cli
ARG PKG_VERSION=2.14.1

FROM balenalib/${ARCH}-debian-python:${PYTHON_VERSION}-build as builder
ARG PKG
ARG PKG_VERSION
RUN [ "cross-build-start" ]
RUN pip3 install wheel \
    && pip3 wheel ${PKG}==${PKG_VERSION} --wheel-dir=/tmp/build-${PKG}
RUN [ "cross-build-end" ]

FROM balenalib/${ARCH}-debian-python:${PYTHON_VERSION}
ARG PKG
COPY --from=builder /tmp/build-${PKG} /tmp/build-${PKG}
WORKDIR /tmp/build-${PKG}
RUN [ "cross-build-start" ]
RUN pip3 install --no-index --find-links=/tmp/build-${PKG} ${PKG} \
    && rm -rf /tmp/build-${PKG}
RUN useradd -m ${PKG}
RUN [ "cross-build-end" ]

USER ${PKG}
WORKDIR /
ENTRYPOINT [ "oci" ]
