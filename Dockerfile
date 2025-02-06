FROM hashicorp/tfc-agent:1.19.0

# tfc-agent image doesn't have sudo or su, so we need to switch users using Docker.
USER root

RUN set -ex \
  && curl -fsSL --compressed -o /tmp/awscliv2.zip 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' \
  && unzip -q /tmp/awscliv2.zip -d /tmp \
  && /tmp/aws/install \
  && rm -rf /tmp/awscliv2.zip /tmp/aws \
  && aws --version

# Switch back to the regular user.
USER tfc-agent
