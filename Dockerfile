FROM python:alpine
LABEL maintainer="kjake"

ADD dehydrated /etc/periodic/daily/dehydrated
RUN apk add --update --no-cache && \
    apk add --no-cache curl openssl bash git && \
    cd / && \
    git clone https://github.com/dehydrated-io/dehydrated && \
    pip3 install --upgrade -t /dehydrated/hooks/cloudflare git+https://github.com/SeattleDevs/letsencrypt-cloudflare-hook && \
    apk del git && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/ ~/.cache/pip && \
    chmod +x /etc/periodic/daily/dehydrated && \
    touch /dehydrated/domains.txt

CMD /etc/periodic/daily/dehydrated && crond -f

VOLUME /dehydrated/certs
