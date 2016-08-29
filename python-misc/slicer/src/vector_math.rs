use ::std::ops::{Mul};
use ::std::num;

trait Vector {
    fn len() -> usize;
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

struct Quaternion {
    real: f64,
    i: f64,
    j: f64,
    k: f64,
}

macro_rules! magnitude {
    ( $x:expr ) => {
        ($x.real + $x.i + $x.j + $x.k).sqrt()
    }
}

impl Quaternion {
    fn new(real: f64, i: f64, j: f64, k: f64) -> Quaternion {
        Quaternion {
            real: real,
            i: i,
            j: j,
            k: k,
        }
    }


    fn inverse(self) -> Quaternion {
        // find the conjugate and divide by magnitude
        let mag = magnitude!(self);
        Quaternion {
            real: self.real / mag,
            i: -self.i / mag,
            j: -self.j / mag,
            k: -self.k / mag,
        }
    }
}

impl Vector for Quaternion {
    fn len() -> usize { 4 }
}

impl Mul for Quaternion {
    type Output = Quaternion;

    fn mul(self, rhs: Quaternion) -> Quaternion {
        Quaternion {
            real: (self.real * rhs.real) - (self.i * rhs.i) - (self.j * rhs.j)
                    - (self.k * rhs.k),
            i: (self.i * rhs.real) + (self.real * rhs.i) - (self.k * rhs.j)
                    + (self.j * rhs.k),
            j: (self.j * rhs.real) + (self.k * rhs.i) + (self.real * rhs.j)
                    - (self.i * rhs.k),
            k: (self.k * rhs.real) - (self.j * rhs.i) + (self.i * rhs.j)
                    + (self.real * rhs.k),
        }
    }
}


