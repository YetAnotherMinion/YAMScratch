use std::io;

fn main() {
    let args: Vec<_> = env::args().collect();
    if args.len() != 3 {
        println!("Useage: {} a b", args[0]);
        return;
    }
    let a = args[1].parse::<i64>().unwrap();
    let b = args[2].parse::<i64>().unwrap();
    let result: i64 = a + b;
    println!("{}", result);

}
