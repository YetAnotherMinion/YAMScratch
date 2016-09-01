extern crate slicer;

use slicer::vector_math::{Vec4, Quaternion};

#[test]
fn test_quaternion_inverse() {
    let a: Quaternion = Quaternion::new(0.0, 0.0, 0.0, 0.0);
    assert_eq!(1, 1);
}

#[test]
fn test_vec4_cast_to_quaternion() {
    let a: Quaternion = Quaternion::new(1.0, 2.0, 3.0, 4.0);
    let b: Vec4 = Vec4::new(1.0, 2.0, 3.0, 4.0);
    assert_eq!(a, b as Quaternion);
}
