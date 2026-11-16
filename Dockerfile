FROM ruby:3.4.12

RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
    apt-get -y --no-install-recommends install \
        vim

WORKDIR /app
CMD ["/bin/bash"]
