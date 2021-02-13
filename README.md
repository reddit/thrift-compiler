# Thrift compiler docker image

This repo builds a Thrift compiler Docker image and pushes it to GitHub
Container Registry.

Use like so:

```thrift
FROM ghcr.io/reddit/thrift-compiler:0.13.0
RUN thrift -help
```

See all available tags here: https://github.com/orgs/reddit/packages/container/package/thrift-compiler
