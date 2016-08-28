mod util;

fn main() {
    let stdin = std::io::stdin();
    let mut buffer = String::new();
    stdin.read_line(&mut buffer).unwrap();
    // assumes that a single number is alone on the first line
    let n_pairs: u64 = buffer.trim().parse::<u64>().ok().unwrap();
    
    let mut result: Vec<i64> = Vec::<i64>::new();
    result.reserve(n_pairs as usize);

    for _ in 0..n_pairs {
        buffer.clear();
        stdin.read_line(&mut buffer).unwrap();
        // it would be more efficient to just parse stream the list  of values
        // on the line into fold, however we want to check the assumptions
        // that there are only two whitespace separated values per line
        let pair: Vec<i64> = buffer.split_whitespace()
                        .filter_map(|x| x.trim().parse::<i64>().ok())
                        .collect();
        assert_eq!(3 as usize, pair.len());
        result.push(util::min_three(pair[0], pair[1], pair[2]))
    }
    for val in result {
        print!("{} ", val);
    }
    print!("\n");
}
