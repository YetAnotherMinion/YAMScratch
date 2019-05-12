#!/usr/bin/env python3

# Definition for singly-linked list.
class ListNode:
    def __init__(self, x, head=None):
        self.val = x
        self.next = head

import queue
from typing import List

# Each list element is visited once, and a push or pop from the queue is log K,
# So we have O(N log K) when using a priority queue.
class Solution:
    def mergeKLists(self, lists: List[ListNode]) -> ListNode:
        q = queue.PriorityQueue()
        for i, node in enumerate(lists):
            if node: q.put((node.val, i, node))

        dummy = current = ListNode(0)

        while not q.empty():
            _, i, current.next = q.get()
            current = current.next
            if current.next: q.put((current.next.val, i, current.next))

        return dummy.next

class SolutionNaive:
    def mergeKLists(self, lists: List[ListNode]) -> ListNode:
        a = []
        for node in lists:
            current = node
            while current is not None:
                a.append(current.val)
                current = current.next


        a.sort()
        dummy = current = ListNode(0)
        for val in a:
            current.next = ListNode(val)
            current = current.next

        return dummy.next

import sys
def print_list_node(current: ListNode):
    while current is not None:
        sys.stdout.write(str(current.val))
        if current.next is not None:
            sys.stdout.write("->")
            current = current.next
        else:
            sys.stdout.write("\n")
            break

from copy import deepcopy

if __name__ == "__main__":
    data = [
        ListNode(1, ListNode(4, ListNode(5))),
        ListNode(1, ListNode(3, ListNode(4))),
        ListNode(2, ListNode(6)),
    ]

    # 144ms on LeetCode
    print_list_node(Solution().mergeKLists(deepcopy(data)))
    # 72ms on LeetCode even though it has worse big O (O(N log N) instead of O(N log k) where k << N)
    print_list_node(SolutionNaive().mergeKLists(data))
