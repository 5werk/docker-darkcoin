FROM debian:jessie
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -u 1234 -d /darkcoin -s /bin/bash darkcoin \
  && chown darkcoin:darkcoin -R /darkcoin

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DARKCOIN_VERSION 0.10.16.16
ENV DARKCOIN_DOWNLOAD_URL https://github.com/darkcoinproject/darkcoin-binaries/raw/master/darkcoin-$DARKCOIN_VERSION-linux.tar.gz
ENV DARKCOIN_SHA256 ea353bd78b621957127392b82c5b36069dd299ea699653622a53f7268f1990e9
RUN cd /tmp \
  && curl -sSL "$DARKCOIN_DOWNLOAD_URL" -o darkcoin.tgz \
  && echo "$DARKCOIN_SHA256 *darkcoin.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf darkcoin.tgz darkcoin-$DARKCOIN_VERSION-linux/bin/64/darkcoind \
  && cp darkcoin-$DARKCOIN_VERSION-linux/bin/64/darkcoind /usr/bin/darkcoind \
  && rm -rf darkcoin* \
  && echo -e "#\x21/bin/bash\n/usr/bin/darkcoind -datadir=/darkcoin \"\$@\"" > /usr/local/bin/darkcoind
RUN chmod a+x /usr/local/bin/darkcoind \
  && chmod a+x /usr/bin/darkcoind

USER darkcoin
ENV HOME /darkcoin
VOLUME ["/darkcoin"]
EXPOSE 9999

# Default arguments, can be overriden
CMD ["darkcoind"]
