FROM python:alpine
LABEL maintainer="redispade"

ADD dehydrated /etc/periodic/daily/dehydrated
RUN apk add --update --no-cache && \
    apk add --no-cache curl openssl bash git && \
    cd / && \
    git clone https://github.com/dehydrated-io/dehydrated && \
    cd dehydrated && \
    mkdir hooks && \
    git clone https://github.com/redispade/letsencrypt-cloudflare-hook hooks/cloudflare && \
    pip3 install -r hooks/cloudflare/requirements.txt && \
    apk del git && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/ ~/.cache/pip && \
    chmod +x /etc/periodic/daily/dehydrated && \
    touch /dehydrated/domains.txt

CMD /etc/periodic/daily/dehydrated && crond -f

VOLUME /dehydrated/certs
