#include <string>
#include <iostream>
#include <cstdint>
#include <vector>
#include <unordered_map>

/* CodeAbbey specifies its own infinite distance value */
const uint64_t INFINITE_DISTANCE = 10000000;

void print_matrix(std::vector<std::vector<uint64_t>>& matrix) {
    for (auto& row : matrix) {
        for (auto val : row) {
            if (val == INFINITE_DISTANCE) {
               std::cout << '#';
            } else {
                std::cout << val;
            }
            std::cout << ' ';
        }
        std::cout << std::endl;
    }
}

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
        roads.push_back(std::make_pair(towns.at(A), towns.at(B)));
    }
    uint64_t n_trips;
    std::cin >> n_trips;
    std::vector<std::pair<uint64_t, uint64_t>> trip_queries;
    for (uint64_t ii = 0; ii < n_trips; ++ii) {
        std::string A, B;
        char seperator;
        std::cin >> A >> seperator >> B;
        /* Program will crash with unhandled exception if trip endpoints were
         * not part of the road network loaded earlier */
        trip_queries.push_back(std::make_pair(towns.at(A), towns.at(B)));
    }


    std::vector<std::vector<uint64_t>> matrix(
            towns.size(),
            std::vector<uint64_t>(towns.size(), INFINITE_DISTANCE)
            );
    
    for (auto& road : roads) {
        matrix[road.first][road.second] = 1;
        matrix[road.second][road.first] = 1;
    }
    for (uint64_t ii = 0; ii < towns.size(); ++ii) {
        matrix[ii][ii] = 0;
    }

    /* for this problem roads are bidirectional so only the lower triangular
     * part of the matrix is calculated */
    for (uint64_t kk= 0; kk < towns.size(); ++kk) {
        for (uint64_t jj = 0; jj < towns.size(); ++jj) {
            for (uint64_t ii = 0; ii < jj; ++ii) {
                if ((matrix[ii][kk] == INFINITE_DISTANCE) ||
                        (matrix[kk][jj] == INFINITE_DISTANCE)) {
                    continue;
                }
                auto candidate = matrix[ii][kk] + matrix[kk][jj];
                if (candidate < matrix[ii][jj]) {
                    matrix[ii][jj] = candidate;
                    matrix[jj][ii] = candidate;
                }
            }
        }
    }

    for (auto& trip : trip_queries) {
        std::cout << matrix[trip.first][trip.second] << ' ';
    }
    std::cout << std::endl;
}
