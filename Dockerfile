FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /tmp

# Install necessary tools
RUN apt-get update && apt-get install -y \
    wget \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*

# Download and install the VeraCrypt CLI .deb package
RUN wget https://launchpad.net/veracrypt/trunk/1.26.20/+download/veracrypt-console-1.26.20-Ubuntu-24.04-amd64.deb \
    && gdebi --non-interactive veracrypt-console-1.26.20-Ubuntu-24.04-amd64.deb \
    && rm veracrypt-console-1.26.20-Ubuntu-24.04-amd64.deb

# Verify installation
RUN veracrypt --text --version

# Clean up
RUN apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/*

CMD ["veracrypt", "--text", "--help"]
