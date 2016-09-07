#include <iostream>
#include <cstdint>
#include <vector>
#include <map>
#include <limits>

#define MY_INFINITY (std::numeric_limits<int64_t>::min())
//node has list of edges encoded as min priority queue
template<typename Key = uint64_t, typename Weight = uint64_t>
struct Node {
    Node() : distance(MY_INFINITY), visted(false) {}

    std::map<Key, Weight> edges;
    int64_t distance;
    bool visted;
};

int main() {
    uint64_t T, N, M, S;
    std::cin >> T;
    std::vector<std::vector<Node<>>> test_cases(T);
    // assume that the number of test cases is limited
    assert(T <= std::numeric_limits<uint8_t>::max());
    for(uint8_t ii = 0; ii < T; ++ii) {
        std::cin >> N >> M;
        test_cases[ii].reserve(N);
        uint64_t x, y, r;
        // Node input is 1 based index, for conveinence translate to zero based
        for(uint32_t jj = 0; jj < M; ++jj) {
            
        }
    }
    // load the start node with all of the other edges

    return 0;
}
