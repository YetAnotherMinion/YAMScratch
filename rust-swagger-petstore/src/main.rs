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

// Finally all the utility crates like logging, time, random.
// Log macros are used globally
#[macro_use]
extern crate log;
extern crate env_logger;


// Provides a macro to define the Mime types
#[macro_use]
extern crate mime;

extern crate url;
extern crate time;


// Next, _register_ the module of this crate here,
// We are putting every handler in the same file for now
mod handlers;


// Then we _import_ the things needed specifically for this module
// starting with iron, its ecosystem, and finally common libraries
use iron::preplude::*
use staticfile::Static;
use mount::Mount;

use std::path::Path;

// **The `main` function** in `src/main.rs` is the entry point for the server
// executable when the server binary is executed. In this project, we setup
// logging, routing, and create the Iron server.
fn main() {
    // The [env_logger](http://doc.rust-lang.org/log/env_logger/index.html)
    // crate makes it easy to specify the log output with the `RUST_LOG`
    // environment variable.
    env_logger::init().unwrap();

    // We have multiple API endpoints, so we setup multiple mount points
    // based on path portion of the URL
    let mut mount = Mount::new();

    // Demonstrate using the
    // [`router!`-macro](http://ironframework.io/doc/router/macro.router!.html)
    // to take every url starting with `/hello_world/` will be routed to 
    // some simple handlers in `handlers.rs`
    // table:
    // ```
    //   METHOD "URL/:keyword" => HANDLER
    // ```
    mount.mount("/hello_world/", router!(
            get "/:value" => hello_world,
            get "/deeper" => rick_roll
    ));

    // Serve static files from the static/ folder.
    // *Note*: we have to define each subfolder seperately as Static _does not_
    // serve recursively as of August 20 2016
    mount.mount("/", Static::new(Path::new("static")));

    // Send a message to the terminal, letting user know we are coming up
    warn!("Server running at 8080");

    // Start serving the routes define on port 8080 on all interfaces
    Iron::new(mount).http("0.0.0.0:8080").unwrap();
}
