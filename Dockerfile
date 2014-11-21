FROM debian:latest
MAINTAINER Chris <chris@5werk.ch>

RUN /usr/sbin/useradd -m -d /darkcoin -s /bin/bash darkcoin
RUN chown darkcoin:darkcoin -R /darkcoin
ENV HOME /darkcoin

ADD darkcoind /usr/local/bin/
RUN chmod a+x /usr/local/bin/darkcoind
ADD darkcoind-starter.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/darkcoind-starter.sh

USER darkcoin
VOLUME ["/darkcoin"]
EXPOSE 9999

ENTRYPOINT ["/usr/local/bin/darkcoind-starter.sh"]

# Default arguments, can be overriden
CMD ["darkcoind", "-server", "-printtoconsole"]
