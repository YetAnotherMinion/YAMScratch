mod bin_packing;

use bin_packing::GuillotineNode as G;

struct Node {
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}


impl Node {
    fn new() -> Node {
        Node {
            left: None,
            right: None,
        }
    }

    fn add_left(&mut self, l: Box<Node>) {
        self.left = Some(l);
    }
}


pub fn main() {
//    let mut b = Node::new();
//    let c = Node::new();
//    b.left = Some(Box::new(c));
    let a = Box::new(G::new(1, 2));
    let b = Box::new(G::new(3, 4));
    let c = G::steve(5, 6, a , b);
}
