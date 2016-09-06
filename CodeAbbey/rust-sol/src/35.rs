struct CompoundInterest {
    principal: i64, // stored as cents
    rate: i64, // as percent
}

impl CompoundInterest {
    pub fn new(principal: i64, rate: i64) -> CompoundInterest {
        CompoundInterest {
            principal: principal * 100,
            rate: rate,
        }
    }
}

impl Iterator for CompoundInterest {
    type Item = i64;

    fn next(&mut self) -> Option<Self::Item> {
        let mut tmp: f64 = (self.principal * self.rate) as f64 / 100.0;
        tmp += self.principal as f64;
        tmp = tmp.floor();
        self.principal = tmp as i64;
        // convert back to dollars
        tmp /= 100.0;
        return Some(tmp as i64);
    }
}

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
        // that there are only three whitespace separated values per line
        let parameters: Vec<i64> = buffer.split_whitespace()
                        .filter_map(|x| x.trim().parse::<i64>().ok())
                        .collect();
        assert_eq!(3 as usize, parameters.len());

        let mut iter = CompoundInterest::new(parameters[0], parameters[2]);
        let mut periods = 0;
        while iter.next().unwrap() < parameters[1] {
            periods += 1;
        }
        // account for the off by one error from not using do while
        periods += 1;
        result.push(periods);
    }
    for val in result {
        print!("{} ", val);
    }
    print!("\n");
}
