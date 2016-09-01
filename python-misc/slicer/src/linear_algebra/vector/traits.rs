#[allow(dead_code)]
pub trait Vector {
    fn len() -> usize;
}

#[allow(dead_code)]
pub trait CrossProduct {
    fn cross_product<T: Vector>(A: T, B: T) -> Option<T>;
    // fn is_orthagnal<T: Vector>(Self, rhs: T) -> bool;
}

use super::vec4::Vec4;
use super::quaternion::Quaternion;

#[allow(dead_code)]
pub enum FourDimensions {
    Vec4,
    Quaternion,
}

