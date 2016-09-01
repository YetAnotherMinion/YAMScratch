#[allow(dead_code)]
#[derive(Debug)]
pub struct GuillotineNode {
    width: f64,
    height: f64,
    x0: f64,
    y0: f64,
    used: bool,
    up: Option<Box<GuillotineNode>>,
    right: Option<Box<GuillotineNode>>,
}

#[allow(dead_code)]
impl GuillotineNode {
    pub fn new(x0: f64, y0: f64, width: f64, height: f64) -> GuillotineNode {
        GuillotineNode {
            width: width,
            height: height,
            x0: x0,
            y0: y0,
            used: false,
            up: None,
            right: None,
        }
    }

//    pub fn steve(x: usize, y: usize, u: Box<GuillotineNode>,
//                     r: Box<GuillotineNode>) -> GuillotineNode {
//        GuillotineNode {
//            x0: x,
//            y0: y,
//            used: false,
//            up: Some(u),
//            right: Some(r),
//        }
//    }
    
    pub fn width(&self) -> f64 {
        match self.right {
            Some(ref right_node) => self.width - right_node.width,
            None => self.width,
        }
    }

    pub fn height(&self) -> f64 {
        match self.up {
            Some(ref top_node) => self.height - top_node.height,
            None => self.height,
        }
    }

    pub fn find_free_node(&self, width: f64, height: f64) ->
        Option<&Box<GuillotineNode>> {
            None        
    }

    pub fn split_node(root: &mut Box<GuillotineNode>,
                      box_width: f64, box_height: f64)-> 
            Option<&Box<GuillotineNode>> {
        /* Depiction of splitting procedure below:
		 *  |<-----root width------>|
         * 	+-----------------------+ ^                                              
         * 	|                       | |                                              
         * 	|         up            | |                                               
         * 	|                       | |                                               
         * 	+--------+--------------+ root height 
         * 	|  box/  |              | |                                               
         * 	|new_root|     right    | |                                              
         * 	+------- +--------------+ V
		 * The root node is the current node, wihch creates two child nodes
		 * when a box is inserted into the root. The root node then becomes the
		 * same size as the box going in.
         */
		// sanity check the invariant that this node should be empty
        match root.up {
            Some(_) => panic!("Cannot allocate an already full node"),
            None => {},
        }
        match root.right {
            Some(_) => panic!("Cannot allocate an already full node"),
            None => {},
        }
        // sanity check that there is enough room to allocate space
        let right_margin = root.width - box_width;
        let top_margin = root.height - box_height;
        if right_margin <= 0.0 || top_margin <= 0.0 {
            return None;
        }

        root.up = Some(Box::new(GuillotineNode::new(root.x0,
                                               root.y0 + box_height,
                                               root.width,
                                               top_margin)));
        root.right = Some(Box::new(GuillotineNode::new(root.x0 + box_width,
                                                   root.y0,
                                                   right_margin,
                                                   box_height)));
        root.used = true;
		Some(root)
    }
}
