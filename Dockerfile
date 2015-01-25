FROM debian:jessie
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -u 1234 -d /darkcoin -s /bin/bash darkcoin \
  && chown darkcoin:darkcoin -R /darkcoin

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DARKCOIN_VERSION 0.11.0.13
ENV DARKCOIN_DOWNLOAD_URL https://github.com/darkcoinproject/darkcoin-binaries/raw/master/darkcoin-$DARKCOIN_VERSION-linux.tar.gz
ENV DARKCOIN_SHA256 396ea93e150ec7c65d895da13f235fecd3399f8b69ad72fd4fa7e3b95b37ce6f
RUN cd /tmp \
  && curl -sSL "$DARKCOIN_DOWNLOAD_URL" -o darkcoin.tgz \
  && echo "$DARKCOIN_SHA256 *darkcoin.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf darkcoin.tgz darkcoin-$DARKCOIN_VERSION-linux/bin/64/darkcoind \
  && cp darkcoin-$DARKCOIN_VERSION-linux/bin/64/darkcoind /usr/bin/darkcoind \
  && rm -rf darkcoin* \
  && echo "#""!/bin/bash\n/usr/bin/darkcoind -datadir=/darkcoin \"\$@\"" > /usr/local/bin/darkcoind \
  && chmod a+x /usr/local/bin/darkcoind \
  && chmod a+x /usr/bin/darkcoind

USER darkcoin
ENV HOME /darkcoin
VOLUME ["/darkcoin"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["darkcoind"]
