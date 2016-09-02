use super::traits::Vector;

use ::std::ops::{Add, Sub, Mul};
use ::std::cmp::PartialEq;

#[allow(dead_code)]
#[derive(Debug, Clone, PartialEq)]
pub struct Quaternion {
    elements: [f64; 4],
}

macro_rules! vec_magnitude {
    ( $x:expr ) => {
        $x.elements.into_iter().fold(0.0, |acc, &x| acc + x.powi(2)).sqrt()
    }
}

#[allow(dead_code)]
impl Quaternion {
    pub fn new(real: f64, i: f64, j: f64, k: f64) -> Quaternion {
        Quaternion {
            elements: [real, i, j, k],
        }
    }

    pub fn real(&self) -> f64 {
        self.elements[0]
    }

    pub fn i(&self) -> f64 {
        self.elements[1]
    }

    pub fn j(&self) -> f64 {
        self.elements[2]
    }

    pub fn k(&self) -> f64 {
        self.elements[3]
    }

    pub fn inverse(self) -> Quaternion {
        // find the conjugate and divide by magnitude
        let mag = vec_magnitude!(self);
        Quaternion {
            // the compiler should be smart enough to choose the best method
            // for computing the reciporical, however use the special method
            // I found in the language docs on the off chance that it is better
            elements: [ self.elements[0] * mag.recip(),
                       -self.elements[1] * mag.recip(),
                       -self.elements[2] * mag.recip(),
                       -self.elements[3] * mag.recip()]
        }
    }
}

#[allow(dead_code)]
impl Mul for Quaternion {
    type Output = Quaternion;

    fn mul(self, rhs: Quaternion) -> Quaternion {
        let a = self.elements[0];
        let b = self.elements[1];
        let c = self.elements[2];
        let d = self.elements[3];
        let w = rhs.elements[0];
        let x = rhs.elements[1];
        let y = rhs.elements[2];
        let z = rhs.elements[3];

        let real =  (a * w) - (b * x) - (c * y) - (d * z);
        let i =     (b * w) + (a * x) - (d * y) + (c * z); 
        let j =     (c * w) + (d * x) + (a * y) - (b * z);
        let k =     (d * w) - (c * x) + (b * y) + (a * z);
        
        Quaternion {
           elements: [real, i, j, k],
        }
    }
}


