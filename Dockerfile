FROM debian:buster-slim
LABEL maintainer="Guerrilla Technology"
LABEL build_date="${TODAY}"
LABEL name=Streamserver
LABEL version=1
LABEL url="https://github.com/GuerrillaTechnology/streamserver"

#
# Install dependencies
#
ARG DEBIAN_FRONTEND=noninteractive
RUN set -ex; \
    apt-get update && \ 
    apt-get install -y --no-install-recommends \
      nginx \
      libnginx-mod-rtmp \
      vlc-bin \
      vlc-plugin-base \
      v4l-utils \
      supervisor && \
    rm -rf /var/lib/apt/lists/*   

#
# Prepare nginx
#
COPY static/nginx.conf /etc/nginx/nginx.conf
COPY static/default.site /etc/nginx/sites-enabled/default
COPY static/stat.xls /var/www/html/stat.xsl
COPY static/index.html /var/www/html/index.html
ADD https://vjs.zencdn.net/7.8.4/video-js.css /var/www/html/video-js.css
ADD https://vjs.zencdn.net/ie8/1.1.2/videojs-ie8.min.js /var/www/html/videojs-ie8.min.js
ADD https://vjs.zencdn.net/7.8.4/video.js /var/www/html/video.js
RUN mkdir /mnt/hls && chown www-data:www-data /mnt/hls /var/www/html/video.js /var/www/html/video-js.css /var/www/html/videojs-ie8.min.js && chmod 755 /mnt/hls && rm /var/www/html/index.nginx-debian.html

#
# Prepare vlc
#
COPY static/stream_camera01.bash /usr/local/bin/stream_camera01.bash
RUN addgroup www-data video && mkdir -p /var/www/.local && chown www-data:www-data /var/www/.local

#
# Prepare supervisord
#
COPY static/hlsvideo.conf /etc/supervisor/conf.d/hlsvideo.conf

#
EXPOSE 80
CMD ["/usr/bin/supervisord"]
