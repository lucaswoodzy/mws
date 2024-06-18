# Stage 1: Build the Rust application
FROM rust:latest as builder
WORKDIR /usr/src/app
COPY masonic-web-services/Cargo.toml .
COPY masonic-web-services/src ./src
RUN apt-get update && apt-get install -y libssl-dev pkg-config
RUN cargo build --release

# Stage 2: Create a minimal runtime image using Ubuntu
FROM ubuntu:24.04
WORKDIR /usr/local/bin
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/src/app/target/release/masonic-web-services /usr/local/bin/masonic-web-services
COPY masonic-web-services/templates /usr/local/bin/templates
COPY masonic-web-services/static /usr/local/bin/static
EXPOSE 8080
CMD ["masonic-web-services"]
