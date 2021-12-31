FROM debian:buster-20211011-slim as base

RUN apt-get update -y && apt-get install curl -y

RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-amd64 -o /bin/bazelisk && \
    chmod +x /bin/bazelisk && \
    bazelisk --help

RUN apt-get install default-jre default-jdk -y
RUN apt-get install -y git

ENV LANG     C.UTF-8
ENV LC_ALL   C.UTF-8
ENV LANGUAGE C.UTF-8

# System deps
RUN apt-get update -y && apt-get install curl gnupg -y && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -y && \
    apt-get install -y nodejs yarn git npm

# without this the build fails:
RUN apt-get install unzip zip -y

# ---------

RUN apt-get install patch -y

RUN mkdir -p /app
WORKDIR /app

# Checkout closure compiler.
RUN git clone --single-branch -b master --no-tags https://github.com/google/closure-compiler
WORKDIR /app/closure-compiler

# Checkout a known-good commit and build.
RUN git checkout 2809700cd70d76b6212cd45540151b90c8d003ba
RUN bazelisk build //:compiler_unshaded_deploy.jar

# Patch
COPY 0001-assumeClosuresOnlyCaptureReferences.patch /app
RUN patch src/com/google/javascript/jscomp/CompilationLevel.java /app/0001-assumeClosuresOnlyCaptureReferences.patch
RUN bazelisk build //:compiler_unshaded_deploy.jar
