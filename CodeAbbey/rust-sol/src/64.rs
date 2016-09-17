fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).ok();
    let (r, c) = {
        let mut iter = buffer.split_whitespace();
        let a = iter.next().unwrap().trim().parse::<u64>().unwrap();
        let b = iter.next().unwrap().parse::<u64>().unwrap();
        (a, b)
    };
    let mut matrix = Vec::<Vec<u64>>::new();
    // read r lines of c characters into the board, converting
    // the walls into a distance of infinity
    for _ in 0..r {
        buffer.clear();
        stdin.read_line(&mut buffer).ok();
        let row: Vec<u64> = buffer.trim()
            .chars().map(|x| {
                match x {
                    '0' => 0,
                    '1' => u64::max_value(),
                    y @ _ => panic!("invalid character {} found in maze", y),
                }
            }).collect();
        assert_eq!(c as usize, row.len());
        matrix.push(row);
    }
        
}

