extern crate actix_web;

use actix_web::{web, App, HttpServer, Responder};
use serde::Serialize;
use log::{debug};
use std::{env, io};

#[derive(Serialize)]
struct User {
  id: String,
  name: String,
  email: String,
}

#[derive(Serialize)]
struct UserLoggedIn {
  loggedIn: bool,
  user: User,
  appId: String,
}

const PORT: i32 = 5500;

async fn user_logged_in() -> impl Responder {
  let user = UserLoggedIn {
    loggedIn: true,
    user: User {
      id: "1".to_string(),
      name: "John Doe".to_string(),
      email: "john@doe.com".to_string(),
    },
    appId: "rust-balancer".to_string(),
  };

  let message: String = format!("[ balancer (RS) ⚖️ ] Called API: /users/logged-in");

  debug!("{}", message);

  return web::Json(user)
}

#[actix_rt::main]
async fn main() -> io::Result<()> {
  env::set_var("RUST_LOG", "debug");
  env_logger::init();

  let message: String = format!("[ balancer (RS) ⚖️ ] Server is listening on {}!", PORT);

  debug!("{}", message);

  HttpServer::new(|| {
    App::new()
      .route("/users/logged-in", web::get().to(user_logged_in))
  })
    .bind(("architect_backend_rust_balancer", 5500))?
    .run()
    .await
}
