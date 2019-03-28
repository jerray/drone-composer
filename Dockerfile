FROM composer:1.8.4

RUN apk -Uuv add ca-certificates git openssh \
    && mkdir -p ~/.ssh ~/.composer && umask 0077

ADD setup.sh /bin/setup.sh
ADD script.sh /bin/script.sh
ENTRYPOINT /bin/script.sh
