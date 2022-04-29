FROM rust:1.59

WORKDIR /usr/src/architect/backend/rust/balancer

COPY ./ ./

RUN cargo install --path .

EXPOSE 5000

CMD ["balancer-rust"]
