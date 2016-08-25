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
}


pub fn main() {
//    let mut b = Node::new();
//    let c = Node::new();
//    b.left = Some(Box::new(c));
    let a = G::new(1, 2);
}
