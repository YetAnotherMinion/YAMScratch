use super::Category;

pub struct Order {
    id: i64,
    pet_id: i64,
    quantity: i64,
    ship_date: String,
    status: String,
    complete: bool,
}
