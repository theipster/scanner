FROM alpine

ENV CONVERT_OPTS="-contrast -fuzz 15% -trim -deskew 10% -modulate 120 +repage"
ENV SCANIMAGE_OPTS="--progress --resolution=300"

RUN apk add --no-cache sane-backends imagemagick

ADD scan.sh .

RUN install scan.sh /usr/bin/scan

ENTRYPOINT ["scan"]
