// **Run as the application, this is the entrypoint**

// First define the crates directly related to the iron web framework
extern crate iron;
extern crate staticfile;
extern crate mount;

// we are using the iron router macro
#[macro_use]
extern crate router;

// Second define all the high level libraries, like serializer, http handling,
// and database
extern crate rustc_serialize;
extern crate hyper;
extern crate postgres;

#[macro_use]
extern crate log;
extern crate env_logger;

#[macro_use]
extern crate mime;

extern crate url;
extern crate time;


// put modules here


use iron::replude::*
use staticfile::Static;
use mount::Mount;

use std::path::Path;

fn hello_world(req: &mut Request) -> IronResult<Response> {
    let mut response = Response::with((status::Ok, "Hello world".to_owned()));
    Ok(reponse)
}

fn rick_roll(req: &mut Request) -> IronResult<Response> {
    let mut response = Response::with((status::Ok, "Never gonna give you up".to_owned()));
    Ok(reponse)
}

fn main() {

    env_logger::init().unwrap();

    let mut mount = Mount::new();

    mount.mount("/hello_world/", router!(
            get "/:value" => hello_world,
            get "/deeper" => rick_roll
    ));

    mount.mount("/", Static::new(Path::new("static")));

    warn!("Server running at 8080");

    Iron::new(mount).http("0.0.0.0:8080").unwrap();
}
