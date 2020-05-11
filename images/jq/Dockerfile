FROM registry.access.redhat.com/ubi8/ubi-minimal
 
RUN curl -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o jq \
  && chmod +x ./jq && cp jq /usr/bin

ENTRYPOINT jq
