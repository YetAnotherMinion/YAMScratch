use itertools::Itertools;
use std::collections::HashSet;
use std::io;
use std::io::BufRead;

fn main() {
    let box_ids: Vec<String> = io::stdin()
        .lock()
        .lines()
        .map(|line| line.unwrap().trim().to_owned())
        .collect();
    let mut two = 0;
    let mut three = 0;
    box_ids
        .iter()
        .map(|line| {
            let counts = line
                .chars()
                .map(|c| (c as u32, ()))
                .into_group_map()
                .iter()
                .map(|(_, g)| g.len())
                .collect::<HashSet<usize>>();
            if counts.contains(&2) {
                two += 1;
            }
            if counts.contains(&3) {
                three += 1;
            }
        })
        .for_each(drop);

    println!("{}", two * three);

    let mut search = HashSet::new();
    'done: for id in box_ids {
        let mut prev_index = 0;
        let mut char_iter = id.char_indices();
        // Skip the first character because we already know it starts on index 0
        char_iter.next();
        let mut seen_last_char = false;
        loop {
            let range = match char_iter.next() {
                Some((index, _)) => {
                    let range = prev_index..index;
                    prev_index = index;
                    range
                }
                None if seen_last_char => break,
                None => {
                    seen_last_char = true;
                    prev_index..id.len()
                }
            };
            let mut wildcard = id.clone();
            wildcard.replace_range(range, "*");
            if !search.insert(wildcard.clone()) {
                // Only report the characters that are the same
                wildcard.retain(|c| c != '*');
                println!("{}", wildcard);
                break 'done;
            }
        }
    }
}
