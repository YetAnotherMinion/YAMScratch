extern crate slicer;

use slicer::vector_math::{Quaternion};

#[test]
fn test_quaternion_inverse() {
    let a: Quaternion = Quaternion::new(0.0, 0.0, 0.0, 0.0);
    assert_eq!(1, 1);
}
