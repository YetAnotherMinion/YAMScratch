extern crate itertools;
use std::collections::HashSet;
use std::io;
use std::io::BufRead;

struct LinkedList {
    prev: usize,
    next: usize,
    value: usize,
}

fn prev(circle: &mut Vec<LinkedList>, cursor: usize) -> usize {
    assert!(cursor < circle.len());
    circle[cursor].prev
}

fn next(circle: &mut Vec<LinkedList>, cursor: usize) -> usize {
    assert!(cursor < circle.len());
    circle[cursor].next
}

fn get(circle: &mut Vec<LinkedList>, cursor: usize) -> usize {
    assert!(cursor < circle.len());
    circle[cursor].value
}

// Remove the node at `cursor`, joining the nodes cursor - 1 and cursor + 1 and return the location
// of cursor + 1
fn remove(circle: &mut Vec<LinkedList>, cursor: usize) -> usize {
    assert!(cursor < circle.len());
    let prev = circle[cursor].prev;
    let next = circle[cursor].next;

    // use sentinal values to mark the node as dead
    circle[cursor].prev = ::std::usize::MAX;
    circle[cursor].prev = ::std::usize::MAX;

    circle[prev].next = next;
    circle[next].prev = prev;

    return next;
}

// Insert the node in between cursor and cursor + 1 and return the index of the new node
fn insert(circle: &mut Vec<LinkedList>, cursor: usize, value: usize) -> usize {
    let new = circle.len();
    let next = circle[cursor].next;
    circle.push(LinkedList {
        prev: cursor,
        next: next,
        value,
    });
    circle[cursor].next = new;
    circle[next].prev = new;

    return new;
}

fn main() {
    const n_players: usize = 458;
    let stop_turn = (72019 * 100);

    let mut score = [0; n_players];

    let mut circle = Vec::with_capacity(stop_turn + 1);
    circle.push(LinkedList {
        prev: 0,
        next: 0,
        value: 0,
    });

    let mut cursor = 0;

    for k in 1..(stop_turn + 1) {
        let player_turn = k % n_players;
        if k % 23 == 0 {
            score[player_turn] += k;
            // Move 7 nodes to left
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            cursor = prev(&mut circle, cursor);
            score[player_turn] += get(&mut circle, cursor);
            cursor = remove(&mut circle, cursor);
        } else {
            // move 1 to left and insert between cursor and cursor + 1
            cursor = next(&mut circle, cursor);
            cursor = insert(&mut circle, cursor, k);
        }
    }
    let mut max_score = 0;
    for s in score.iter() {
        if *s > max_score {
            max_score = *s;
        }
    }
    println!("max score was {}", max_score);
}
