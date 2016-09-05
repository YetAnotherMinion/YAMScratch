mod util;

use std::cmp::PartialOrd;
use std::fmt::Display;

#[derive(Debug)]
pub struct BinaryNode<T> {
    value: T,
    left: Option<Box<BinaryNode<T>>>,
    right: Option<Box<BinaryNode<T>>>,
}

fn moving<T>(v: T) -> T { v }

impl<T: PartialOrd + Display> BinaryNode<T> {
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

    pub fn to_string(&self) -> String {
        let mut result: String = "(".to_string();
        let left_content = match self.left {
            Some(ref x) => x.to_string(),
            None => "-".to_string(),
        };
        result.push_str(&*left_content);
        result.push_str(",");
        result.push_str(&*self.value.to_string());
        result.push_str(",");
        let right_content = match self.right {
            Some(ref x) => x.to_string(),
            None => "-".to_string(),
        };
        result.push_str(&*right_content);
        result.push_str(")");
        result
    }
}


//impl<T: std::fmt::Display> std::fmt::Display for BinaryNode<T> {
//    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
//        write!(f, "{}", "(");
//        match self.left {
//            Some(ref x) => write!(f, "{}", x),
//            None => write!(f, "{}", "-"),
//        }
//    }
//}

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
    println!("{}", root.to_string());
}
