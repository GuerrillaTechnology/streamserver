# Streamserver

Streamserver is a multi-architecture (arm7 & arm64) Docker image for providing the video feed of an attached camera as a hls encoded video stream. The target platform is an Logitech C920 connected to a Raspberry Pi 3, the current configuration delivers 1920x1080 at 30 fps h264 encoded vidoe with a delay of ~30s and an systemload increas of about 0.1 

## Processing Pipeline

   - v4l driver for the camera
   - cvlc to capture the h264 encoded video, mux as FLV and send using RTMP
   - nginx (with rtmp module) re-mux the video to hls and server the files
   - videojs for playback in browsers

## Usage
In order to reduce wear on the SD card, the temporary video files (/mnt/hls) should be stored in RAM using a SD card. 

In the the root of the webserver is a webpage with videojs ready to be embeded, eg http://localhost/
The hls files are available in /video/camera01/index.m3u8
Nginx streaming stats are availabel in /stats/

### Docker
```sh 
docker run -p 80:80 --device /dev/video0:/dev/video0 --tmpfs /mnt/hls guerrillatechnology/streamserver:latest
```
### Docker Compose
```yaml
version: "3.8"
services:
  streamserver:
    container_name: streamserver
    image: guerrillatechnology/streamserver:latest
    ports:
      - 80:80
    devices:
      - /dev/video0:/dev/video0
    tmpfs:
      - /mnt/hls
```

Released under the MIT licence.