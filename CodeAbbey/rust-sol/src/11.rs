fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    let n = buffer.trim().parse::<u64>().unwrap();
    
    let base: u64 = 10;
    for _ in 0..n {
        buffer.clear();
        stdin.read_line(&mut buffer).unwrap();
        let data: Vec<i64> = buffer.split_whitespace()
                        .filter_map(|x| x.trim().parse::<i64>().ok())
                        .collect();
        assert_eq!(3, data.len());
        let a = data[0];
        let b = data[1];
        let c = data[2];
        let mut d: u64 = (a * b + c).abs() as u64;
        let mut digit_sum: u64 = 0;
        while d > 0 {
            digit_sum += d % base;
            d /= base;
        }
        print!("{} ", digit_sum);
    }
    print!("\n");
}
