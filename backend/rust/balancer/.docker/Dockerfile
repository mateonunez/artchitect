FROM rust:1.61-alpine

# Setting env variables
ENV BALANCER_HOST architect_backend_rust_balancer
ENV BALANCER_PORT 5500

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates musl-dev \
  && rm -rf /var/lib/apt/lists/*

# Creating and checkout the directory
RUN mkdir -p /usr/src/architect/backend/rust/balancer
WORKDIR /usr/src/architect/backend/rust/balancer

# Installing the dependencies
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock

# Copying the env file
COPY .env .env

# Replace the env variables
RUN envsubst '${BALANCER_HOST},${BALANCER_PORT}' < .env

# Copy the application
COPY src src

## Install target platform (Cross-Compilation) --> Needed for Alpine
RUN rustup target add x86_64-unknown-linux-musl

# Install cargo
RUN cargo build --target x86_64-unknown-linux-musl --release
RUN mv target/x86_64-unknown-linux-musl/release/balancer-rust /usr/local/bin/balancer-rust

# Run the application in dev mode
CMD ["balancer-rust"]
