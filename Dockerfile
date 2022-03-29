FROM debian:11

# Install dependencies.
RUN apt-get update && \
  apt-get install --assume-yes curl gcc libgmp-dev libpq-dev make xz-utils zlib1g-dev

# Install Stack.
RUN curl -k --location https://www.stackage.org/stack/linux-x86_64-static > stack.tar.gz && \
  tar xf stack.tar.gz && \
  cp stack-*-linux-x86_64-static/stack /usr/local/bin/stack && \
  rm -f -r stack.tar.gz stack-*-linux-x86_64-static/stack && \
  stack --version

# Build
WORKDIR /project
COPY . /project
RUN stack build --copy-bins --local-bin-path /usr/local/bin
