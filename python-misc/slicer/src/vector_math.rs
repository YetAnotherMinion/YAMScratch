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

macro_rules! quaterion_magnitude {
    ( $x:expr ) => {
        ($x.real.powi(2) + $x.i.powi(2) + $x.j.powi(2) + $x.k.powi(2)).sqrt()
    }
}

macro_rules! vec_magnitude {
    ( $x:expr ) => {
        x.elements.fold(0.0, |acc, x| acc + x.powi(2)).sqrt()
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
        let mag = quaterion_magnitude!(self);
        Quaternion {
            // the compiler should be smart enough to choose the best method
            // for computing the reciporical, however use the special method
            // I found in the language docs on the off chance that it is better
            real: self.real * mag.recip(),
            i: -self.i * mag.recip(),
            j: -self.j * mag.recip(),
            k: -self.k * mag.recip(),
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


