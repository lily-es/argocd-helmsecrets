FROM argoproj/argocd:latest

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
# (e.g. curl, awscli, gpg, sops)
RUN apt-get update && \

    apt-get install -y \
        curl \
        awscli \
        gpg \
	jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/3.2.0/sops-3.2.0.linux && \
    chmod +x /usr/local/bin/sops && \
    mv /usr/local/bin/helm /usr/local/bin/helm3

COPY assume.sh /usr/local/bin/assume.sh
COPY helm /usr/local/bin/helm

# Switch back to non-root user
USER argocd

RUN helm plugin install https://github.com/futuresimple/helm-secrets

ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
