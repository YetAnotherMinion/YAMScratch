#[allow(dead_code)]
pub fn min_three<T>(a: T, mut b: T, mut c: T) -> T where T: PartialOrd {
    if a < b {
        b = a;
    }
    if b < c {
        c = b
    }
    c
}
