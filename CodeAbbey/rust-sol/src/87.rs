mod util;

use std::cmp::PartialOrd;

pub struct BinaryNode<T> {
    value: T,
    left: Option<Box<BinaryNode<T>>>,
    right: Option<Box<BinaryNode<T>>>,
}

fn moving<T>(v: T) -> T { v }

impl<T: PartialOrd> BinaryNode<T> {
    pub fn new(val: T) -> BinaryNode<T> {
        BinaryNode::<T> {
            value: val,
            left: None,
            right: None,
        }
    }

    pub fn insert(root: &mut Self, val: T) {
        // toy example, only insert the value to the left
        let mut cursor = root;
        loop {
            if val < cursor.value {
                match moving(cursor).left {
                    Some(ref mut child) => {
                            cursor = &mut **child;
                        },
                    ref mut slot @ None => {
                            *slot = Some(Box::new(Self::new(val)));
                            break;
                        },
                }
            } else {
                match moving(cursor).right {
                    Some(ref mut child) => {
                            cursor = &mut **child;
                        },
                    ref mut slot @ None => {
                            *slot = Some(Box::new(Self::new(val)));
                            break;
                        },
                }
            }
        } 
    }
}

fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    let n = buffer.trim().parse::<u64>().ok().unwrap();

    buffer.clear();
    stdin.read_line(&mut buffer).unwrap();
    let data: Vec<i64> = buffer.split_whitespace()
                     .filter_map(|x| x.trim().parse::<i64>().ok()).collect();
    
    assert_eq!(n as usize, data.len());

    let mut iter = data.into_iter();
    let mut root = BinaryNode::<i64>::new(iter.next().unwrap());
    for val in iter {
        BinaryNode::<i64>::insert(&mut root, val);
    }

    print!("\n");
}
