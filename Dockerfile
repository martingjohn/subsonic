FROM openjdk:8

ENV VERSION 6.1.3
ENV INSTALL_DIR /opt/subsonic

ENV SUBSONIC_HOME /home/subsonic
ENV SUBSONIC_HOST 0.0.0.0
ENV SUBSONIC_PORT 4040
ENV SUBSONIC_HTTPS_PORT 0
ENV SUBSONIC_CONTEXT_PATH /
ENV SUBSONIC_MAX_MEMORY 150
ENV SUBSONIC_DEFAULT_MUSIC_FOLDER /opt/music
ENV SUBSONIC_DEFAULT_PODCAST_FOLDER /opt/podcast
ENV SUBSONIC_DEFAULT_PLAYLIST_FOLDER /opt/playlists

WORKDIR $INSTALL_DIR

RUN apt-get update \
 && apt-get install -y \
            ffmpeg \
 && rm -rf /var/lib/apt/lists/* \
 && wget -O- --quiet "https://sourceforge.net/projects/subsonic/files/subsonic/$VERSION/subsonic-$VERSION-standalone.tar.gz/download"| tar zxv -C $INSTALL_DIR

CMD mkdir -p ${SUBSONIC_HOME}/transcode && \
    ln -fs /usr/bin/ffmpeg ${SUBSONIC_HOME}/transcode/ffmpeg && \
    java -Xmx${SUBSONIC_MAX_MEMORY}m \
         -Dsubsonic.home=${SUBSONIC_HOME} \
         -Dsubsonic.host=${SUBSONIC_HOST} \
         -Dsubsonic.port=${SUBSONIC_PORT} \
         -Dsubsonic.httpsPort=${SUBSONIC_HTTPS_PORT} \
         -Dsubsonic.contextPath=${SUBSONIC_CONTEXT_PATH} \
         -Dsubsonic.db="${SUBSONIC_DB}" \
         -Dsubsonic.defaultMusicFolder=${SUBSONIC_DEFAULT_MUSIC_FOLDER} \
         -Dsubsonic.defaultPodcastFolder=${SUBSONIC_DEFAULT_PODCAST_FOLDER} \
         -Dsubsonic.defaultPlaylistFolder=${SUBSONIC_DEFAULT_PLAYLIST_FOLDER} \
         -Djava.awt.headless=true \
         -verbose:gc \
         -jar subsonic-booter-jar-with-dependencies.jar

