FROM alpine:3.12.0

# Disable file system caching as described 
# in <https://github.com/ytdl-org/youtube-dl#configuration>
RUN echo -e '--no-cache-dir \n' >> /etc/youtube-dl.conf

ARG BASH_VERSION=5.0.17-r0
ARG FFMPEG_VERSION=4.3.1-r0
ARG YOUTUBE_DL_VERSION=2020.05.29-r0
ARG JQ_VERSION=1.6-r1
ARG TINI_VERSION=0.19.0-r0


RUN apk update && apk add --upgrade --no-cache \
    bash=${BASH_VERSION} \
    ffmpeg=${FFMPEG_VERSION} \
    youtube-dl=${YOUTUBE_DL_VERSION} \
    jq=${JQ_VERSION} \
    tini=${TINI_VERSION}

WORKDIR "/usr/local/bin"

ADD yt2ab.sh yt2ab
RUN chmod +x yt2ab

VOLUME ["/data"]

WORKDIR "/data"

# Leverage 'tini' for PID 1;
# see <https://hynek.me/articles/docker-signals/> for details
ENTRYPOINT ["tini", "-v", "--", "yt2ab"]
