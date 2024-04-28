FROM linuxserver/webtop:ubuntu-xfce-version-1e71751f
RUN rm /etc/apt/sources.list.d/docker.list && \
    apt update && \
    apt install -y --no-install-recommends \
      thunderbird \
      thunderbird-locale-da \
      firefox-locale-da \
      firefox-esr-locale-da \
      apt-transport-https \
      bash-completion \
      ca-certificates \
      wget \
      git \
      curl \
      gpg && \
    curl -fsSL  https://updates.signal.org/desktop/apt/keys.asc | \
      gpg --dearmor -o /usr/share/keyrings/signal-desktop-keyring.gpg && \
    curl -fsSL https://baltocdn.com/helm/signing.asc | gpg --dearmor -o /usr/share/keyrings/helm.gpg && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' \
      >/etc/apt/sources.list.d/signal-xenial.list && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" \
      >/etc/apt/sources.list.d/helm-stable-debian.list && \  
    echo 'deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' > /etc/apt/sources.list.d/kubernetes.list && \
    apt update && \
    apt install -y --no-install-recommends \
      signal-desktop \
      kubectl \
      helm && \
    curl -s https://fluxcd.io/install.sh | bash && \
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && \
    mv kustomize /usr/local/bin/ && \
    helm completion bash > /etc/bash_completion.d/helm && \
    kubectl completion bash > /etc/bash_completion.d/kubectl && \
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /etc/bash_completion.d/git && \
    apt-get autoclean && \
    rm -rf \
      /config/.cache \
      /var/lib/apt/lists/* \
      /var/tmp/* \
      /tmp/*
