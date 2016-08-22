// First
extern crate iron;
extern crate rustc_serialize;
extern crate hyper;
extern crate url;

extern crate router;

use std::vec::Vec;
use rustc_serialize::json::Json;

use iron::modifiers::Redirect;
use iron::headers::{CacheControl, CacheDirective};
use iron::prelude::*;
use iron::status;
use iron::Url as iUrl;

use hyper::client::Client;
use router::Router;


pub fn hello_world(req: &mut Request) -> IronResult<Response> {                     
    let mut response = Response::with((status::Ok, "Hello world".to_owned()));  
    Ok(response)                                                                 
}                                                                               
                                                                                
pub fn rick_roll(req: &mut Request) -> IronResult<Response> {                       
    let mut response = Response::with((status::Ok, "Never gonna give you up".to_owned(    )));
    Ok(response)
}

