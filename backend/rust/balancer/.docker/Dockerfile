FROM rust:1.59

WORKDIR /usr/src/architect/backend/rust

# Creates new project
RUN USER=root cargo new balancer

COPY Cargo.* /usr/src/architect/backend/rust/balancer

WORKDIR /usr/src/architect/backend/rust/balancer

RUN cargo build --release

COPY src /usr/src/architect/backend/rust/balancer/src/

RUN cargo build --release \
  && mv target/release/balancer-rust /bin 

WORKDIR /

EXPOSE 5500

CMD ["/bin/balancer-rust"]
