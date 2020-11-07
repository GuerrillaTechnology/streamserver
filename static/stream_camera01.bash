#!/bin/bash
v4l2-ctl -d/dev/video0 --set-fmt-video=width=1920,height=1080,pixelformat=1 --set-ctrl=led1_mode=0
cvlc v4l2:///dev/video0:chroma=h264:width=1920:height=1080 --sout '#standard{access=rtmp,mux=flv,dst=rtmp://127.0.0.1:1935/video/camera01' -vvv
