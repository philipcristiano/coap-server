FROM node:10 as NODE_BUILDER
WORKDIR /app/src/
ADD . /app/src
RUN npm install
RUN npm run build

FROM erlang:23.0.2 AS builder
WORKDIR /app/src
ADD . /app/src
RUN rm -rf /app/src/deps /app/src/_rel

COPY --from=NODE_BUILDER /app/src/priv/public/ /app/src/priv/public/
RUN make deps app
RUN make rel
RUN mv /app/src/_rel/coap_server_release/coap_server_*.tar.gz /app.tar.gz

FROM debian:buster

RUN apt-get update && apt-get install -y openssl && apt-get clean

COPY --from=builder /app.tar.gz /app.tar.gz

WORKDIR /app

RUN tar -xzf /app.tar.gz
ADD config/default.config /kimball/app.config

CMD ["/app/bin/coap_server_release", "foreground"]
