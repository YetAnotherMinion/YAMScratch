#include <iostream>
#include <vector>
#include <cstdint>
#include <cassert>
#include <array>


uint64_t computeKeyFromName(char name) {
    /* only capital letters A-Z are used as city names in this problem */
    return name - 'A';
}

struct City {
    City() : name(0) {};

    char name;
    std::vector<uint64_t> adj;
};

int main(int argc, char* argv[]) {
    uint64_t n_maps;
    std::cin >> n_maps;
    /* For each road map, we use a fixed size array which correspond to the
     * possible cities because each City is labeled with an uppercase character
     * This completely avoids pointers, as well as building lookups for each
     * city name to its data structure */
    std::vector<std::array<City, 26>> road_maps;
    std::vector<bool> map_has_cycle;
    road_maps.reserve(n_maps);

    for (uint64_t ii = 0; ii < n_maps; ++ii) {
        uint64_t n_roads, n_nodes, n_edges;
        std::cin >> n_roads;
        road_maps.emplace_back();
        auto& road_network = *road_maps.rbegin();
        n_nodes = n_edges = 0;
        for (uint64_t jj = 0; jj < n_roads; ++jj) {

            char A, B, seperator;
            std::cin >> A >> seperator >> B;
            assert('-' == seperator);
            assert(A != B);
            n_edges++;
            /* bind new names that will be optmized out */
            auto& town_A = road_network[computeKeyFromName(A)];
            auto& town_B = road_network[computeKeyFromName(B)];

            if (!town_A.name) {
                n_nodes++;
                town_A.name = A;
            }
            if (!town_B.name) {
                n_nodes++;
                town_B.name = B;
            }

            town_A.adj.push_back(computeKeyFromName(B));
            town_B.adj.push_back(computeKeyFromName(A));
        }
        /* If there are N nodes and more than N-1 edges, there must be cycles
         * If we cannot tell then we will process them later */
        map_has_cycle.push_back(n_edges >= n_nodes);
    }
    for (auto v : map_has_cycle) {
        /* prints 0 for maps that have no cycles */
        std::cout << (v ? 1 : 0) << ' ';
    }
    std::cout << std::endl;
}
