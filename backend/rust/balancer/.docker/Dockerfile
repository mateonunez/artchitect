FROM rust:1.61-alpine

# Setting env variables
ENV BALANCER_HOST balancer_rust
ENV BALANCER_PORT 5500

# Installing main dependencies
RUN apk update \
  && apk add gettext ca-certificates musl-dev \
  && rm -rf /var/lib/apt/lists/*

# Creating and checkout the directory
RUN mkdir -p /usr/src/architect/backend/rust/balancer
WORKDIR /usr/src/architect/backend/rust/

# We want dependencies cached, so copy those first.
COPY Cargo.toml Cargo.lock /usr/src/architect/backend/rust/balancer/

# Set the working directory
WORKDIR /usr/src/architect/backend/rust/balancer/

## Install target platform (Cross-Compilation) --> Needed for Alpine
# RUN rustup target add x86_64-unknown-linux-musl

RUN mkdir -p src && touch src/main.rs && echo "fn main() {}" > src/main.rs

# This is a dummy build to get the dependencies cached.
# RUN cargo build --target x86_64-unknown-linux-musl --release | This works on Windows Docker Desktop
RUN cargo build  --release

# Copying the env file
COPY .env.example .env

# Replace the env variables
RUN envsubst '${BALANCER_HOST},${BALANCER_PORT}' < .env

# Now copy in the rest of the sources
COPY src src

## Touch main.rs to prevent cached release build
RUN touch src/main.rs

# This is the actual application build.
RUN cargo build --release
# RUN mv target/x86_64-unknown-linux-musl/release/balancer-rust /usr/local/bin/balancer-rust | This works on Windows Docker Desktop

# Copy the binary to the /usr/bin directory
RUN mv target/release/balancer-rust /usr/local/bin/balancer-rust
# RUN mv target/x86_64-unknown-linux-musl/release/balancer-rust /usr/local/bin/balancer-rust | This works on Windows Docker Desktop

# Run the application in dev mode
CMD ["balancer-rust"]
