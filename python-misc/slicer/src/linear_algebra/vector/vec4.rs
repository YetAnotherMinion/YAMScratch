use super::traits::Vector;

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct Vec4 {
    elements: [f64; 4],
}

#[allow(dead_code)]
impl Vec4 {
    pub fn new(a: f64, b: f64, c: f64, d: f64) -> Vec4 {
        Vec4 {
            elements: [a, b, c, d]
        }
    }
}

#[allow(dead_code)]
impl Vector for Vec4 {
    fn len() -> usize { 4 }
}
