use std::io;

fn main() {
   let stdin = io::stdin();
   let mut buffer = String::new();
   stdin.read_line(&mut buffer).unwrap();
   let n: u64 = buffer.trim().parse::<u64>().ok().unwrap();

   buffer.clear();
   stdin.read_line(&mut buffer).unwrap();
   let data: Vec<i64> = buffer.split_whitespace()
                              .filter_map(|x| x.trim().parse::<i64>().ok())
                              .collect();

   assert_eq!(n as usize, data.len());
   let sum: i64 = data.iter().fold(0, |acc, x| acc + x);
   println!("{}", sum);
}
