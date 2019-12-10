use std::io;
use std::io::{BufRead};
use std::collections::HashSet;

fn main() {
    let stdin = io::stdin();
    let deltas: Vec<i64>= stdin.lock().lines().map(|line| line.unwrap().trim().parse::<i64>().unwrap()).collect();
    println!("result: {}", deltas.iter().fold(0, |sum, d| sum + d));
    
    
    let mut memo = HashSet::new(); 
    memo.insert(0);
    let mut sum = 0;
    for d in deltas.iter().cycle() {
        sum += d;
        if memo.contains(&sum) {
            break;
        }
        memo.insert(sum);
    }
    println!("first_duplicate: {}", sum);
}
