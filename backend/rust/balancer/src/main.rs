use actix_web::{web, App, HttpRequest, HttpServer, Responder};

const PORT: i32 = 5000;

async fn say_hi() -> impl Responder {
  format!("Hello guest, I'm a Balancer running on the port: {}!", PORT)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
  HttpServer::new(|| {
    App::new()
        .route("/", web::get().to(say_hi))
  })
  .bind(("127.0.0.1", 5000))?
  .run()
  .await
}