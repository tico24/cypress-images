FROM ubuntu:20.04

# You can get chrome versions from here because Google makes it very hard to find: https://chromium.cypress.io/
ENV FIREFOX_VERSION=81.0
ENV CHROME_VERSION 86.0.4240.75

# Which timezone would you like?
ENV TZ=Europe/London

# apt install dependencies
# I'm not convinced you need all of these, but that's what's in the current image has.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq update \
    && apt-get -qq install --no-install-recommends -yq -o Dpkg::Options::="--force-confnew" \
    apt-transport-https \
    curl \
    build-essential \
    git \
    unzip \
    tzdata \
    libgbm1 \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xvfb \
    fonts-liberation \
    libappindicator3-1 \
    xdg-utils \
    wget \
    zip \
    mplayer \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get -qq update && apt-get -qq install -y nodejs npm \
  && rm -rf /var/lib/apt/lists/*

# Install latest NPM and Yarn
RUN npm install -g npm@latest
RUN npm install -g yarn@latest

# a few environment variables to make NPM installs easier
# good colors for most applications
ENV TERM xterm
# avoid million NPM install messages
ENV npm_config_loglevel warn
# allow installing when the main user is root
ENV npm_config_unsafe_perm true

# install Chrome browser
RUN wget -O /usr/src/google-chrome-stable_current_amd64.deb "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}-1_amd64.deb" && \
  dpkg -i /usr/src/google-chrome-stable_current_amd64.deb ; \
  apt-get install -f -y && \
  rm -f /usr/src/google-chrome-stable_current_amd64.deb

# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# install Firefox browser
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${FIREFOX_VERSION}/linux-x86_64/en-US/firefox-${FIREFOX_VERSION}.tar.bz2" \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && ln -fs /opt/firefox/firefox /usr/bin/firefox

# Set Timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
