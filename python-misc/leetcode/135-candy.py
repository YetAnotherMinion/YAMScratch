from typing import List

class Solution:
    def candy(self, ratings: List[int]) -> int:
        candies = [ 1 for _ in range(len(ratings)) ]
        for i in range(1, len(ratings)):
            prev = i - 1
            if ratings[i] > ratings[prev]:
                candies[i] = candies[prev] + 1

        for i in range(len(ratings) - 1, 0, -1):
            
            if ratings[i] < ratings[ i - 1 ]:
                candies[i - 1] = max(candies[i-1], candies[i] + 1)

        return sum(candies)


print(Solution().candy([1,2,2]))
        
        
