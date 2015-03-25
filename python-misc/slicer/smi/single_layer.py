

class SingleLayer(object):
    def __init__(self, dimension):
        self.dimension = dimension
        self.min_coord = None
        self.max_coord = None
        self.lines = []
        self.recompute_size_flag = True
        #hold the fit into the tree
        self.fit = None

    def updateBoundingBox(self, test_point):
        #check to see if they are updated yet
        if self.max_coord is not None:
            for index in range(0, self.dimension):
                if test_point[index] < self.min_coord[index]:
                    self.min_coord[index] = test_point[index]
                if test_point[index] > self.max_coord[index]:
                    self.max_coord[index] = test_point[index]
        else:
            self.min_coord = [x for x in test_point]
            self.max_coord = [x for x in test_point]

    def addLineSegment(self, point_a, point_b):
        together = tuple([point_a, point_b])
        self.lines.append(together)
        for test_point in together:
            self.updateBoundingBox(test_point)
        #reset the flag so the method knows when to recompute
        self.recompute_size_flag = True

    def width():
        doc = "The width property."
        def fget(self):
            if self.recompute_size_flag:
                self._width = abs(self.max_coord[0] - self.min_coord[0])
                self._height = abs(self.max_coord[1] - self.min_coord[1])
                self.recompute_size_flag = False
            return self._width
        def fset(self, value):
            self._width = value
        def fdel(self):
            del self._width
        return locals()
    width = property(**width())

    def height():
        doc = "The height property."
        def fget(self):
            if self.recompute_size_flag:
                self._width = abs(self.max_coord[0] - self.min_coord[0])
                self._height = abs(self.max_coord[1] - self.min_coord[1])
                self.recompute_size_flag = False
            return self._height
        def fset(self, value):
            self._height = value
        def fdel(self):
            del self._height
        return locals()
    height = property(**height())

    def area(self):
        return self.width*self.height