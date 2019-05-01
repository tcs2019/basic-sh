FROM alpine:latest
RUN apk add --no-cache geth  && \
  apk add --no-cache nodejs-npm && \
  apk add --no-cache redis
# TODO: copy needed files into docker image
# COPY 
# CMD ["./start.sh"]
EXPOSE 3000 8545 8546 30303 30303/udp