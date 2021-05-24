FROM alpine:3.13
LABEL maintainer="Pedro Paes <plpbs@poli.br>"

RUN apk add --no-cache postgresql curl bash python3 py3-pip openssl && \
    rm -rf /var/cache/apk/* && \
    pip3 install b2; \
    curl -L --insecure https://github.com/odise/go-cron/releases/download/v0.0.6/go-cron-linux.gz | zcat > /usr/local/bin/go-cron; \
	chmod u+x /usr/local/bin/go-cron

ENV POSTGRES_DATABASE **None**
ENV POSTGRES_HOST **None**
ENV POSTGRES_PORT 5432
ENV POSTGRES_USER **None**
ENV POSTGRES_PASSWORD **None**
ENV POSTGRES_EXTRA_OPTS ''
ENV B2_BUCKET **None**
ENV B2_KEY_ID **None**
ENV B2_KEY **None**
ENV SCHEDULE **None**

ADD run.sh run.sh
ADD backup.sh backup.sh

CMD ["sh", "run.sh"]
