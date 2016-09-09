fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    let n = buffer.trim().parse::<u64>().unwrap();
    for _ in 0..n {
        buffer.clear();
        stdin.read_line(&mut buffer).unwrap();
        let point_data: Vec<i64> = buffer.split_whitespace()
                        .filter_map(|x| x.trim().parse::<i64>().ok())
                        .collect();
        let x1 = point_data[0];
        let y1 = point_data[1];
        let x2 = point_data[2];
        let y2 = point_data[3];
        let m = (y2 - y1) / (x2 - x1);
        let b = y1 - m * x1;
        print!("({} {}) ", m ,b);
    }
    print!("\n");
}
