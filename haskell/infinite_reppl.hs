import qualified Data.Map as Map
import Data.Maybe


--replace first element of list with element from front
-- of infinte list passed in
foo :: [String] -> [String] -> [String]
foo target infinite = r1 : foo t infiniteTail
	where
		r1:infiniteTail = infinite
		h:t = target

foo [] infinite = []
foo _ = error "needs two arguments"

fooWrapper :: [String] -> [String]
fooWrapper input = foo input inf
	where inf = ["a", "b", "c"] ++ ["var" ++ show x | x <- [1..]]



-- driver for test
x = ["f", "g", "h", "j", "k"]
fooWrapper x
