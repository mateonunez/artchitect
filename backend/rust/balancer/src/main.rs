extern crate actix_web;

use actix_web::{web, App, HttpServer, Responder};
use log::{debug, info};
use std::{env, io};

const PORT: i32 = 5500;

async fn say_hi() -> impl Responder {
  let message: String = format!("Hello guest, I'm a Balancer running on the port: {}!", PORT);
  debug!("{}", message);

  message
}

#[actix_rt::main]
async fn main() -> io::Result<()> {
  env::set_var("RUST_LOG", "debug");
  env_logger::init();

  HttpServer::new(|| App::new().route("/", web::get().to(say_hi)))
    .bind(("architect_backend_rust_balancer", 5500))?
    .run()
    .await
}
