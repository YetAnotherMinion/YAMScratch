use super::Category;

pub struct Order {
    id: i64,
    petId: i64,
    quantity: i64,
    shipDate: String,
    status: String,
    complete: bool,
}
