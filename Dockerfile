FROM golang:1.19-bullseye

# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV TZ=Europe/Warsaw

# Define which Neovim COC extensions should be installed.
ARG COC='coc-css coc-eslint coc-go coc-html coc-json coc-sh coc-sql coc-tsserver coc-yaml'

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    && apt-get install --no-install-recommends --assume-yes zsh fzf xz-utils \ 
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && curl -fLo ~/nvim-linux64.deb https://github.com/neovim/neovim/releases/download/v0.8.0/nvim-linux64.deb \
    && apt install ~/nvim-linux64.deb && rm ~/nvim-linux64.deb \
    && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    && curl -fLo ~/node-v18.12.1-linux-x64.tar.xz https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.xz \
    && tar -xJf ~/node-v18.12.1-linux-x64.tar.xz -C /usr/local --strip-components=1 --no-same-owner \
    && rm ~/node-v18.12.1-linux-x64.tar.xz \ 
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && mkdir -p /root/.config/coc/extensions && cd /root/.config/coc/extensions \
    && npm install $COC --only=prod

COPY ./spell/ /root/.local/share/nvim/site/spell/
COPY ./config/ /root/.config/nvim/
# Install Neovim extensions.
RUN nvim --headless +PlugInstall +qall \
    && nvim +'silent :GoInstallBinaries' +qall

CMD ["sleep", "infinity"]
