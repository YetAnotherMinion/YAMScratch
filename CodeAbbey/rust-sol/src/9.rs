fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    let n = buffer.trim().parse::<u64>().unwrap();

    for _ in 0..n {
        buffer.clear();
        stdin.read_line(&mut buffer).unwrap();
        let triangle: Vec<u64> = buffer.split_whitespace()
                             .filter_map(|x| x.trim().parse::<u64>().ok())
                             .collect();
        assert_eq!(3, triangle.len());
        let mut a = triangle[0];
        let mut b = triangle[1];
        let mut c = triangle[2];
        // find the maximum length and put it in c
        if b > c {
            let tmp = c;
            c = b;
            b = tmp;
        }
        if a > c {
            let tmp = c;
            c = a;
            a = tmp;
        }
        if a + b < c {
            print!("0 ");
        } else {
            print!("1 ");
        }
    }
    print!("\n");

}
