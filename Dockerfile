ARG ARCH=armv7hf
ARG PKG=PyYAML

FROM balenalib/${ARCH}-debian-python:build as builder
ARG PKG
RUN [ "cross-build-start" ]
RUN pip3 install wheel \
    && python3 -c "import wheel.pep425tags as w; print('\n'.join(['-'.join(p) for p in w.get_supported()]))" \
    && pip3 wheel ${PKG} --wheel-dir=/tmp/build-${PKG}
RUN [ "cross-build-end" ]

FROM balenalib/${ARCH}-debian-python
ARG PKG
COPY --from=builder /tmp/build-${PKG} /tmp/build-${PKG}
WORKDIR /tmp/build-${PKG}
RUN [ "cross-build-start" ]
RUN ls /tmp/build-${PKG} \
    && pip3 install wheel \
    && python3 -c "import wheel.pep425tags as w; print('\n'.join(['-'.join(p) for p in w.get_supported()]))"
RUN pip3 install --no-index --find-links=/tmp/build-${PKG} PyYAML-5.3.1-cp38-cp38-linux_armv7l.whl \
    && rm -rf /tmp/build-${PKG}
RUN useradd -m ${PKG}
RUN [ "cross-build-end" ]

USER ${PKG}

ENTRYPOINT [ "oci" ]
