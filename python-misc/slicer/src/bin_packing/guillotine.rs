pub struct GuillotineNode {
    pub x0: usize,
    pub y0: usize,
    up: Option<Box<GuillotineNode>>,
    right: Option<Box<GuillotineNode>>,
}

impl GuillotineNode {
    pub fn new(x: usize, y: usize) -> GuillotineNode {
        GuillotineNode {
            x0: x,
            y0: y,
            up: None,
            right: None,
        }
    }

    pub fn steve(x: usize, y: usize, u: Box<GuillotineNode>,
                     r: Box<GuillotineNode>) -> GuillotineNode {
        GuillotineNode {
            x0: x,
            y0: y,
            up: Some(u),
            right: Some(r),
        }
    }
}
