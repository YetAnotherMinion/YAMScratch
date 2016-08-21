use std::vec::Vec;

use super::Category;
use super::Tag;

pub struct Pet {
    id: i64,
    category: Category,
    name: String,
    photoUrls: Vec<String>,
    tags: Vec<Tag>,
    status: String,
}
