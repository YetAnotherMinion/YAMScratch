#include <iostream>
#include <iomanip>
#include <limits>
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

void print_edges(std::vector<Node<>>& nodes) {
    for(auto& rv: nodes) {
        std::cout << rv.self_index << "\n";
        for(auto& edge : rv.edges) {
            std::cout << "\t" << rv.self_index << " -> " << edge.first
                << ": " << edge.second << "\n";
        }
    }
    std::cout << std::endl;
}

void print_board(std::vector<std::vector<int64_t>> board) {
    const auto INFINITY = std::numeric_limits<int64_t>::min();
    for(auto& row : board) {
        for(auto& val : row) {
            if(val == INFINITY) {
                std::cout << std::setw(3) << "I";
            } else {
                std::cout << std::setw(3) << val;
            }

        }
        std::cout << std::endl;
    }

}

int main() {
    // relabel all the nodes from 0 to N-1
    uint64_t M, N, Q;
    std::cin >> N >> M;
    std::vector<Node<>> nodes(N, Node<>(0));
    auto index = 0;
    for(auto& node : nodes) {
        node.self_index = index++;
    }
    // The next M lines are edge definitions
    for(uint64_t ii = 0; ii < M; ++ii) {
        uint64_t x,y;
        int64_t w;
        std::cin >> x >> y >> w;
        // sanity checks on input
        assert(x <= N); assert(y <= N);
        // edges are directed from x->y
        nodes[x-1].edges[y-1] = w;
    }
    //print_edges(nodes);
    // HACK: Use int64_t min value to indicate infinite distance
    const auto INFINITY = std::numeric_limits<int64_t>::min();
    std::vector<std::vector<int64_t>> dist(N, 
                                           std::vector<int64_t>(N, INFINITY));
    for(uint64_t i = 0; i < N; ++i) {
        dist[i][i] = 0;
    }
    // initialize all the edge weights
    for(auto& node : nodes) {
        for(auto& edge : node.edges) {
            dist[node.self_index][edge.first] = edge.second;
        }
    }
    print_board(dist);
    // return 0;
    for(uint64_t k = 0; k < N; ++k) {
        for(uint64_t i = 0; i < N; ++i) {
            for(uint64_t j = 0; j < N; ++j) {
                // check that each leg of the purposed shorter path exists
                if ((dist[i][k] == INFINITY) || (dist[k][j] == INFINITY)) {
                    std::cout << "skipping" << std::endl;
                    continue;
                }
                // not a new path
                if(i == k || j == k) {
                    std::cout << "not a new path" << std::endl;
                    continue;
                }
                auto candiate_path = dist[i][k] + dist[k][j];
                std::cout << "candiate " << i << " -> " << j << " = "
                    << candiate_path << " using " << i << " -> " << k << " -> "
                    << j << std::endl;
                if (INFINITY == dist[i][j] ||
                        dist[i][j] > candiate_path) {
                    std::cout << "Setting dist[" << i << "][" << j << "] = "
                        << candiate_path << std::endl;
                    dist[i][j] = candiate_path;
                }
                // check for negative cycles
                if ((dist[j][j] != INFINITY) && (dist[j][j] < 0)) {
                    std::cout << "Negative cycle at step:" << k << '\n'
                        << "\tIncludes node " << j+1 << '\n'
                        << "\tValue: " << dist[j][j] << '\n'
                        << "\tInfinity: " << INFINITY << std::endl;
                    exit(1);
                }
            }
        }
    }
    std::cin >> Q;
    for(uint64_t ii = 0; ii < Q; ++ii) {
        uint64_t x, y;
        std::cin >> x >> y;
        // remember to translate from 1 based indexing of nodes to the zero
        // based format we use
        int64_t distance = (dist[x-1][y-1] == INFINITY) ? -1 : dist[x-1][y-1];
        std::cout << distance << std::endl;
    }

    return 0;
}
