use super::traits::Vector;

#[allow(dead_code)]
#[derive(Debug, Clone)]
pub struct Vec3 {
    elements: [f64; 3],
}

#[allow(dead_code)]
impl Vec3 {
    pub fn new(i: f64, j: f64, k: f64) -> Vec3 {
        Vec3 {
            elements: [i, j, k],
        }
    }
}

#[allow(dead_code)]
impl Vector for Vec3 {
    fn len() -> usize { 3 }
}

