--tripleMe::(Number x) => Number -> Number
tripleMe x = x + x + x

doubleLargeNumber x = if x > 100
						then x*2
						else x

map' ::( a -> b) -> [a] -> [b]
map' _ [] = []
map' f (h:t) = f h : map' f t

--functions cannot start with capital letters, since those are reseved for Types

{- head returns first element of list
	tail returns the list with the head chopped off
	
-}
