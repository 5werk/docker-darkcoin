FROM debian:jessie
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -u 1234 -d /darkcoin -s /bin/bash darkcoin \
  && chown darkcoin:darkcoin -R /darkcoin

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DARKCOIN_VERSION 0.10.16.15
ENV DARKCOIN_DOWNLOAD_URL https://github.com/darkcoinproject/darkcoin-binaries/raw/master/darkcoin-$DARKCOIN_VERSION-linux.tar.gz
ENV DARKCOIN_SHA256 cecb70c26284f2b3dd47af3250a581abeb84defbc9afd1dc43a290ceee79c48d
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
