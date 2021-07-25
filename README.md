# docker-tsduck-static

> A Docker image for [TSDuck](https://tsduck.io),
> statically compiled with `musl`

[![CI](https://github.com/ep76/docker-tsduck-static/actions/workflows/ci.yml/badge.svg?branch=main)](
  https://github.com/ep76/docker-tsduck-static/actions/workflows/ci.yml
)
[![DockerHub](https://img.shields.io/docker/v/ep76/tsduck-static/latest?label=tsduck-static)](
  https://hub.docker.com/r/ep76/tsduck-static/tags?page=1&ordering=last_updated
)
[![DockerHub](https://img.shields.io/docker/v/ep76/libtsduck-static/latest?label=libtsduck-static)](
  https://hub.docker.com/r/ep76/libtsduck-static/tags?page=1&ordering=last_updated
)

## Usage

### In shell

```shell
$ docker run --rm ep76/tsduck-static:latest --version
# <version string>
```

### In Dockerfile

```Dockerfile
# For the binaries:
COPY --from=ep76/tsduck-static:latest /usr /usr
# For the library:
COPY --from=ep76/libtsduck-static:latest /usr /usr
```

## License

[MIT](./LICENSE)
