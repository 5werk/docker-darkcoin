FROM debian:latest
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -d /darkcoin -s /bin/bash darkcoin \
  && chown darkcoin:darkcoin -R /darkcoin

RUN apt-get update \
  && apt-get install -y curl \
  && rm -rf /var/lib/apt/lists/*

ENV DARKCOIN_VERSION 0.10.16.16
ENV DARKCOIN_DOWNLOAD_URL https://github.com/darkcoinproject/darkcoin-binaries/raw/master/darkcoin-0.10.16.16-linux.tar.gz
ENV DARKCOIN_SHA256 ea353bd78b621957127392b82c5b36069dd299ea699653622a53f7268f1990e9
RUN cd /tmp \
  && curl -sSL "$DARKCOIN_DOWNLOAD_URL" -o darkcoin.tgz \
  && echo "$DARKCOIN_SHA256 *darkcoin.tgz" | /usr/bin/sha256sum -c - \
  && tar xzf darkcoin.tgz darkcoin-0.10.16.16-linux/bin/64/darkcoind \
  && cp darkcoin-0.10.16.16-linux/bin/64/darkcoind /usr/local/bin/darkcoind \
  && rm -rf darkcoin*
ADD darkcoind-starter.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/darkcoind \
  && chmod a+x /usr/local/bin/darkcoind-starter.sh

USER darkcoin
ENV HOME /darkcoin
VOLUME ["/darkcoin"]
EXPOSE 9999

ENTRYPOINT ["/usr/local/bin/darkcoind-starter.sh"]

# Default arguments, can be overriden
CMD ["darkcoind", "-server", "-printtoconsole"]
