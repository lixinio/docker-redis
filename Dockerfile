FROM redis:4.0.9-alpine

RUN apk add --no-cache bash sed wget ca-certificates \
      && wget -q -O /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.9.6/bin/linux/amd64/kubectl \
      && chmod +x /usr/local/bin/kubectl

COPY conf /etc/redis/
COPY bin /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/redis-launcher.sh"]
