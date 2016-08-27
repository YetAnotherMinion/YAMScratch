use std::io;

fn main() {
    let mut stdin = io::stdin();
    let input = &mut String::new();

    stdin.read_line(input);
    let mut iter = input.split_whitespace();
    let a: i64 = iter.next().unwrap().parse::<i64>().ok().unwrap();
    let b: i64 = iter.next().unwrap().parse::<i64>().ok().unwrap();

    println!("{}", a + b);
}
