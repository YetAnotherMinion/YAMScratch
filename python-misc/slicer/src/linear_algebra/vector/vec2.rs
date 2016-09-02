use super::traits::Vector;

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct Vec2 {
    elements: [f64; 2],
}

impl Vec2 {
    pub fn new(a: f64, b: f64) -> Vec2 {
        Vec2 {
            elements: [a, b],
        }
    }
}

impl Vector for Vec2 {
    fn len() -> usize { 2 }
}
