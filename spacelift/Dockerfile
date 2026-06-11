# Spacelift explicitly does not version their runner image
# https://docs.spacelift.io/integrations/docker#standard-runner-image
FROM public.ecr.aws/spacelift/runner-terraform:v2.5.0

# Spacelift runner image doesn't have sudo or su, so we need to switch users using Docker.
USER root

# Base dependencies
RUN set -ex && apk update \
  && apk add --no-cache \
    curl \
    gnupg \
    unzip

# Install buildah and related tooling for building container images.
RUN set -ex && apk update \
  && apk add --no-cache \
    buildah \
    crun \
    fuse-overlayfs \
    shadow-uidmap

# kubectl
ARG KUBECTL_VERSION="v1.33.12"
RUN set -ex \
  && curl -fsSL --compressed -o /tmp/kubectl "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /tmp/kubectl \
  && mv /tmp/kubectl /usr/local/bin/kubectl
RUN kubectl version --client

# AWS CLI
RUN pip install awscli --break-system-packages
RUN aws --version

# gcloud CLI
COPY --from=gcr.io/google.com/cloudsdktool/google-cloud-cli:572.0.0-alpine /google-cloud-sdk /google-cloud-sdk
ENV PATH=/google-cloud-sdk/bin:$PATH
# gcloud auth plugin
RUN gcloud components install gke-gcloud-auth-plugin
RUN gcloud --version && gke-gcloud-auth-plugin --version

# Switch back to the regular user.
USER spacelift
