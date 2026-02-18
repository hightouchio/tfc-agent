FROM hashicorp/tfc-agent:1.28.3

# tfc-agent image doesn't have sudo or su, so we need to switch users using Docker.
USER root

RUN set -ex \
  && curl -fsSL --compressed -o /tmp/awscliv2.zip 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' \
  && unzip -q /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install \
  && rm -rf /tmp/awscliv2.zip /tmp/aws \
  && aws --version

RUN set -ex \
  && curl -fsSL --compressed -o /tmp/kubectl "https://dl.k8s.io/release/v1.31.6/bin/linux/amd64/kubectl" \
  && chmod +x /tmp/kubectl \
  && mv /tmp/kubectl /usr/local/bin/kubectl \
  && kubectl version --client

# Install buildah and related tooling for building container images.
RUN set -ex \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    buildah \
    fuse-overlayfs \
    uidmap \
  && rm -rf /var/lib/apt/lists/*

# Switch back to the regular user.
USER tfc-agent
