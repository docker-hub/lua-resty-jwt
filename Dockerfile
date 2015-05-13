FROM debian:jessie

WORKDIR /lua-resty-jwt

ENV OPENRESTY_VERSION 1.7.10.1

RUN apt-get update && \
    apt-get install -y libpcre3 curl build-essential libpcre3-dev libssl-dev git && \
    curl http://openresty.org/download/ngx_openresty-${OPENRESTY_VERSION}.tar.gz | tar zxvf - && \
    cd ngx_openresty-${OPENRESTY_VERSION} && \
    ./configure --prefix=/usr && make && make install && \
    cd ..; rm -rf ngx_openresty-${OPENRESTY_VERSION} && \
    git clone https://github.com/openresty/test-nginx.git && \
    cd test-nginx && \
    perl Makefile.PL && \
    make && \
    make install && \
    cpan install Test::Base && \
    git clone --depth 1 https://github.com/jkeys089/lua-resty-hmac.git hmac && \
    cp -r hmac/lib/resty/* /usr/lualib/resty/ && \
    rm -rf hmac && \
    apt-get purge -y git curl build-essential libpcre3-dev libssl-dev && \
    apt-get -y autoremove && \
    apt-get clean

RUN ln -s /usr/nginx/sbin/nginx /usr/sbin/nginx

COPY . /lua-resty-jwt/
