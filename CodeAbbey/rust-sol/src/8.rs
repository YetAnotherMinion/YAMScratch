use std::ops::AddAssign;

struct ArithmeticProgression<T> {
    step: T,
    value: T,
}

impl<T> ArithmeticProgression<T> {
    fn new(intial_value: T, step: T) -> ArithmeticProgression<T> {
        ArithmeticProgression {
            step: step,
            value: intial_value,
        }
    }
}

impl<T: AddAssign + Clone> Iterator for ArithmeticProgression<T> {
    type Item = T;

    fn next(&mut self) -> Option<Self::Item> {
        let result = self.value.clone();
        self.value += self.step.clone();
        Some(result)
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
        // that there are only two whitespace separated values per line
        let parameters: Vec<i64> = buffer.split_whitespace()
                        .filter_map(|x| x.trim().parse::<i64>().ok())
                        .collect();
        assert_eq!(3 as usize, parameters.len());
        let iter = ArithmeticProgression::new(parameters[0], parameters[1]);
        
        result.push(iter.take(parameters[2] as usize)
                        .fold(0, |acc, x| acc + x));
    }
    for val in result {
        print!("{} ", val);
    }
    print!("\n");
}
