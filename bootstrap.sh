#!/bin/bash
sudo apt-get update

sudo apt-get install -y -qq \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    git \
    python3-pip \
    python3-dev \
    python3-dev \
    zsh \
    neovim \
    yarn \
    python-neovim \
    python3-neovim \
    postgresql \
    postgresql-contrib \
    libpq-dev \
    mosh \
    redis-server \
    libc6 \
    libglapi-mesa \
    libxdamage1 \
    libxfixes3 \
    libxcb-glx0 \
    libxcb-dri2-0 \
    libxcb-dri3-0 \
    libxcb-present0 \
    libxcb-sync1 \
    libxshmfence1 \
    libxxf86vm1 \
    --no-install-recommends

if [ ! -d "${HOME}/.zsh" ]; then
  echo " ==> Installing zsh plugins"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.zsh/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-autosuggestions "${HOME}/.zsh/zsh-autosuggestions"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "${HOME}/Dropbox" ]; then
    pushd "${HOME}" && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -
    popd
fi

if [ ! -d "${HOME}/.fzf" ]; then
  echo " ==> Installing fzf"
  git clone https://github.com/junegunn/fzf "${HOME}/.fzf"
  pushd "${HOME}/.fzf"
  git remote set-url origin git@github.com:junegunn/fzf.git
  ${HOME}/.fzf/install --bin --64 --no-bash --no-zsh --no-fish
  popd
fi

echo "==> Setting shell to zsh..."
chsh -s /usr/bin/zsh

echo "==> Creating dev directories"
mkdir -p /root/code

if [ ! -d /root/code/dotfiles ]; then
  echo "==> Setting up dotfiles"
  # the reason we dont't copy the files individually is, to easily push changes
  # if needed
  cd "/root/code"
  git clone --recursive https://github.com/serg-e/dotfiles.git

  cd "/root/code/dotfiles"
  git remote set-url origin git@github.com:serg-e/dotfiles.git

  ln -sfn $(pwd)/.config "${HOME}/.config"
  ln -sfn $(pwd)/.zshrc  "${HOME}/.zshrc"
  ln -sfn $(pwd)/.gitconfig  "${HOME}/.gitconfig"
fi

# pyenv
if [ ! -d "${HOME}/.pyenv" ]; then
    echo "==> Setting up pyenv"
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

if ! grep -qF 'PYENV_ROOT' ${HOME}/.zshrc; then
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
fi


#poetry
if [ ! -d "${HOME}/.poetry" ]; then
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
fi

if ! grep -qF 'export PATH=$HOME/.poetry/bin:$PATH' ${HOME}/.zshrc; then
    echo 'export PATH=$HOME/.poetry/bin:$PATH' >> ~/.zshrc
fi

#VimPlug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


