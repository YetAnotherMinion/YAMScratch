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
    let mut a = Box::new(G::new(1.0, 2.0, 10.0, 10.0));
    let b = Box::new(G::new(3.0, 4.0, 10.0, 10.0));
    //let c = G::steve(5, 6, a , b);
    G::split_node(&mut a, 4.0, 5.0);
}
