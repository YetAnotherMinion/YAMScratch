mod util;

fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    let mut iter = buffer.split_whitespace()
                     .filter_map(|x| x.trim().parse::<i64>().ok());

    let n = iter.next().unwrap();
    let result: Vec<i64> = iter.map(|x| {
                                    util::round((x - 32) as f64 * 5.0 / 9.0)
                                })
                               .collect();
    
    assert_eq!(n as usize, result.len());

    for val in result {
        print!("{} ", val);
    }
    print!("\n");
}
