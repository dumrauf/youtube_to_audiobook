FROM alpine:3.12.0

# Install most dependencies via OS package manager
ARG BASH_VERSION=5.0.17-r0
ARG FFMPEG_VERSION=4.3.1-r0
ARG JQ_VERSION=1.6-r1
ARG PY3_SETUPTOOLS_VERSION=47.0.0-r0
ARG PYTHON3_VERSION=3.8.5-r0
ARG TINI_VERSION=0.19.0-r0
RUN apk update && apk add --upgrade --no-cache \
    bash=${BASH_VERSION} \
    ffmpeg=${FFMPEG_VERSION} \
    py3-setuptools=${PY3_SETUPTOOLS_VERSION} \
    python3=${PYTHON3_VERSION} \
    jq=${JQ_VERSION} \
    tini=${TINI_VERSION}


# Install `youtube-dl` manually
ARG YOUTUBE_DL_VERSION=2020.9.20
RUN python3 -m ensurepip && \
    pip3 install --disable-pip-version-check --upgrade --no-cache-dir youtube_dl==${YOUTUBE_DL_VERSION} && \
    pip3 uninstall -y pip

# Disable file system caching for `youtube-dl` as described 
# in <https://github.com/ytdl-org/youtube-dl#configuration>
RUN echo -e '--no-cache-dir \n' >> /etc/youtube-dl.conf


# Install `yt2ab`
WORKDIR "/usr/local/bin"
ADD yt2ab.sh yt2ab
RUN chmod +x yt2ab


# Define and leverage `data` volume
VOLUME ["/data"]
WORKDIR "/data"


# Leverage 'tini' for PID 1 as suggested in
# <https://hynek.me/articles/docker-signals/>
ENTRYPOINT ["tini", "-v", "--", "yt2ab"]


# Add Git commit information
ARG SOURCE_COMMIT=undefined
ENV SOURCE_COMMIT=${SOURCE_COMMIT}
LABEL SourceCommit=${SOURCE_COMMIT}
ARG SOURCE_BRANCH=undefined
ENV SOURCE_BRANCH=${SOURCE_BRANCH}
LABEL SourceBranch=${SOURCE_BRANCH}
