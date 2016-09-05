mod quicksort;

pub use self::quicksort::min_three;

#[allow(dead_code)]
pub fn round(mut c: f64) -> i64 {
    c += if c < 0.0 { -0.5  } else { 0.5 };
    c as i64
}
