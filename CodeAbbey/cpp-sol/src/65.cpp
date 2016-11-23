#include <string>
#include <iostream>
#include <cstdint>
#include <algorithm>
#include <vector>
#include <unordered_map>

int main(int argc, char* argv[]) {
    uint64_t n_routes;
    std::cin >> n_routes;

    uint64_t index = 0;
    std::unordered_map<std::string, uint64_t> towns;
    std::vector<std::pair<uint64_t, uint64_t>> roads;

    for(uint64_t ii = 0; ii < n_routes; ++ii) {
        std::string A, B;
        char seperator;
        std::cin >> A >> seperator >> B;
        auto prev_size = towns.size();
        towns.insert(std::make_pair(A, index));
        if (towns.size() != prev_size) {
            index++;
            prev_size = towns.size();
        }
        towns.insert(std::make_pair(B, index));
        if (towns.size() != prev_size) {
            index++;
        }
        roads.push_back(std::make_pair(towns[A], towns[B]));
    }

    std::vector<std::vector<uint64_t>> matrix(
            towns.size(),
            std::vector<uint64_t>(towns.size(),
                                  std::numeric_limits<uint64_t>::max())
            );
    
    for (auto& road : roads) {
        matrix[road.first][road.second] = 1;
        matrix[road.second][road.first] = 1;
    }
    for (uint64_t ii = 0; ii < towns.size(); ++ii) {
        matrix[ii][ii] = 0;
    }
    const auto INFINITE_DISTANCE = std::numeric_limits<uint64_t>::max();

    for (uint64_t kk= 1; kk < towns.size(); ++kk) {
        for (uint64_t jj = 0; jj < towns.size(); ++jj) {
            for (uint64_t ii = 0; ii < jj; ++ii) {
                if ((matrix[ii][kk] == INFINITE_DISTANCE) ||
                        (matrix[kk][jj] == INFINITE_DISTANCE)) {
                    continue;
                }
                auto candidate = matrix[ii][kk] = matrix[kk][jj];
                if (candidate < matrix[ii][jj]) {
                    matrix[ii][jj] = matrix[jj][ii] = candidate;
                }
            }
        }
    }

    // print the matrix
}
