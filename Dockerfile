FROM alpine:3.6

ENV DOCKER_CLIENT_VERSION="19.03.1"
ENV TERRAFORM_VERSION="0.11.7"
ENV KUBECTL_VERSION="1.17.3"
ENV YQ_VERSION="2.1.1"
ENV KUSTOMIZE_VERSION="3.5.4"

WORKDIR /tmp

# Install dependencies
RUN apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    git \
    gnupg \
    libc6-compat \
    openssh-client \
    py-crcmod \
    python \
    tar \
    unzip \
    wget \
    && rm -rf /var/cache/apk/*

# Install Docker
RUN curl --location https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_CLIENT_VERSION}.tgz --output /tmp/docker.tgz && \
    tar --extract --gzip --directory /tmp --file /tmp/docker.tgz && \
    mv /tmp/docker/* /usr/local/bin && \
    docker --version && \
    rm -rf /tmp/*

# Install Terraform
RUN curl --location https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform --version && \
    rm -rf /tmp/*

# Install Kubectl
RUN curl --location https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl --output /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client -o yaml

# Install yq
RUN curl --location https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 --output /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# Install Kustomize
RUN curl --location https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz --output kustomize.tar.gz && \
    tar xzf kustomize.tar.gz && \
    mv kustomize /usr/local/bin/kustomize && \
    chmod +x /usr/local/bin/kustomize && \
    kustomize version

VOLUME ["/root/.config"]
