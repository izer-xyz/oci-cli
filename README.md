# oci-cli
ARM (armv7hf) build for [oracle/oci-cli](https://github.com/oracle/oci-cli)

 * uses Balena.io [cross-build](https://www.balena.io/docs/reference/base-images/base-images/#building-arm-containers-on-x86-machines) feature - see [Dockerfile](Dockerfile)
 * runs on GitHub Actions - see [docker-image.yml](.github/workflows/docker-image.yml)
 * pushes to GitHub container repository [izer-xyz](https://github.com/orgs/izer-xyz/packages/container/package/oci-cli)
