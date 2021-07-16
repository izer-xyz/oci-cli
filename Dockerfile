ARG ARCH=armv7hf
ARG PYTHON_VERSION=3.8
ARG PKG=oci-cli
ARG PKG_VERSION=2.25.4

FROM balenalib/${ARCH}-debian-python:${PYTHON_VERSION}-build as builder
ARG PKG
ARG PKG_VERSION
ARG ARCH
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN if [ ${ARCH} = "armv7hf" ] ; then [ "cross-build-start" ] ; fi

RUN pip3 install wheel \
    && pip3 wheel ${PKG}==${PKG_VERSION} --wheel-dir=/tmp/build-${PKG}
RUN if [ ${ARCH} = "armv7hf" ] ; then [ "cross-build-end" ] ; fi

FROM balenalib/${ARCH}-debian-python:${PYTHON_VERSION}
ARG PKG
ARG ARCH
COPY --from=builder /tmp/build-${PKG} /tmp/build-${PKG}
WORKDIR /tmp/build-${PKG}
RUN if [ ${ARCH} = "armv7hf" ] ; then [ "cross-build-start" ] ; fi
RUN pip3 install --no-index --find-links=/tmp/build-${PKG} ${PKG} \
    && rm -rf /tmp/build-${PKG}
RUN useradd -m ${PKG}
RUN if [ ${ARCH} = "armv7hf" ] ; then [ "cross-build-end" ] ; fi

USER ${PKG}
WORKDIR /
ENTRYPOINT [ "oci" ]
