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
            Some(_) => return None,
            None => {},
        }
        match root.right {
            Some(_) => return None,
            None => {},
        }
        if(1==1) {

        }

        print!("{:?}\n", root.up);
		Some(root)
    }
}
