use ::std::ops::{Mul};
use ::std::num;


trait Vector {
    fn len() -> usize;
}

macro_rules! vec_magnitude {
    ( $x:expr ) => {
        $x.elements.into_iter().fold(0.0, |acc, &x| acc + x.powi(2)).sqrt()
    }
}


trait CrossProduct {
    fn cross_product<T: Vector>(A: T, B: T) -> Option<T>;
    // fn is_orthagnal<T: Vector>(Self, rhs: T) -> bool;
}

struct Vec3 {
    elements: [f64; 3],
}

impl Vec3 {
    fn new(i: f64, j: f64, k: f64) -> Vec3 {
        Vec3 {
            elements: [i, j, k],
        }
    }
}

impl Vector for Vec3 {
    fn len() -> usize { 3 }
}


pub enum FourDimensions {
    Vec4,
    Quaternion,
}



pub struct Vec4 {
    elements: [f64; 4],
}

impl Vec4 {
    fn new(a: f64, b: f64, c: f64, d: f64) -> Vec4 {
        Vec4 {
            elements: [a, b, c, d]
        }
    }
}

impl Vector for Vec4 {
    fn len() -> usize { 4 }
}

pub struct Quaternion {
    elements: [f64; 4],
}

impl Quaternion {
    fn real(&self) -> f64 {
        self.elements[0]
    }

    fn i(&self) -> f64 {
        self.elements[1]
    }

    fn j(&self) -> f64 {
        self.elements[2]
    }

    fn k(&self) -> f64 {
        self.elements[3]
    }

    fn inverse(self) -> Vec4 {
        // find the conjugate and divide by magnitude
        let mag = vec_magnitude!(self);
        Vec4 {
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

