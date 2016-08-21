
fn hello_world(req: &mut Request) -> IronResult<Response> {                     
    let mut response = Response::with((status::Ok, "Hello world".to_owned()));  
    Ok(reponse)                                                                 
}                                                                               
                                                                                
fn rick_roll(req: &mut Request) -> IronResult<Response> {                       
    let mut response = Response::with((status::Ok, "Never gonna give you up".to_owned(    )));
    Ok(response)
}

