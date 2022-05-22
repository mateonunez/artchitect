FROM rust:1.59

WORKDIR /usr/src/architect/backend/rust/balancer/

# Creates new project
COPY . /usr/src/architect/backend/rust/balancer/

RUN cargo build --release \
  && mv target/release/balancer-rust /bin 

CMD ["/bin/balancer-rust"]
