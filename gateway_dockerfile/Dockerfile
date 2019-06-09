FROM alpine:latest
RUN apk add --no-cache geth  && \
  apk add --no-cache nodejs-npm && \
  apk add --no-cache redis
# TODO: copy needed files into docker image then run nmp install
# https://stackoverflow.com/questions/37789984/how-to-copy-folders-to-docker-image-from-dockerfile
RUN mkdir /gateway
ADD .src $HOME/gateway
# CMD ["./start.sh"]
EXPOSE 3000 8545 8546 30303 30303/udp