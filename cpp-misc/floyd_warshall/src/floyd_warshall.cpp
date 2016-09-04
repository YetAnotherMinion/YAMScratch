#include <iostream>
#include <cassert>
#include <vector>
#include <cstdint>
#include <map>

template<typename Key = uint64_t, typename Weight = int64_t>
struct Node {
    Node(Key index): self_index(index) {}

    std::map<Key, Weight> edges;
    Key self_index;
};

int main() {
    // relabel all the nodes from 0 to N-1
    uint64_t M, N;
    std::cin >> N >> M;
    std::vector<Node<>> nodes(N, Node<>(0));
    auto index = 0;
    for(auto& node : nodes) {
        node.self_index = index++;
    }
    for(auto ii = 0; ii < M; ++ii) {
        uint64_t x,y;
        int64_t w;
        std::cin >> x >> y >> w;
        // sanity checks on input
        assert(x <= N); assert(y <= N);
        // edges are directed from x->y
        nodes[x-1].edges[y-1] = w;
    }
    for(auto& rv: nodes) {
        std::cout << rv.self_index << "\n";
        for(auto& edge : rv.edges) {
            std::cout << "\t" << rv.self_index << " -> " << edge.first
                << ": " << edge.second << "\n";
        }
    }
    std::cout << std::endl;
    return 0;
}
