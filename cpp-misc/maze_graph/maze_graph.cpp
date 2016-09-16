#include <vector>
#include <algorithm>
#include <limits>
#include <iostream>
#include <cstdint>
#include <map>

struct Node {
    Node() : distance(0) {}

    std::vector<uint32_t> edges;
    uint32_t distance;
};

/* returns the graph index of the start and stop of the maze */
std::pair<uint32_t, uint32_t> convert_maze_to_graph(
        const std::vector<std::vector<uint8_t>> &maze,
        const uint32_t x0, /* start of maze */
        const uint32_t y0,
        const uint32_t x1, /* endpoint of maze */
        const uint32_t y1,
        std::vector<Node> &graph,
        std::vector<uint32_t> &checkpoints)
{
    graph.clear();
    checkpoints.clear();
    std::pair<uint32_t, uint32_t> result;
    std::map<uint32_t, uint32_t> maze_to_graph;    
    const uint8_t WALL = '1';
    const uint8_t SPACE = '0';
    const uint8_t CHECKPOINT = '2';
    uint32_t ii = 0, jj = 0;
    uint32_t maze_index = 0;
    for(const auto& row : maze) {
        jj = 0;
        for(const auto cell : row) {
            if (ii == x0 && jj == y0) {
                if(cell != SPACE && cell != CHECKPOINT) {
                    std::cerr << "Starting point is not valid maze position"
                        << std::endl;
                    exit(2);
                }
                result.first = graph.size();
            }
            if (ii == x1 && jj == y1) {
                if(cell != SPACE && cell != CHECKPOINT) {
                    std::cerr << "Ending point is not valid maze position"
                        << std::endl;
                    exit(2);
                }
                result.second = graph.size();
            }
            if ((SPACE == cell) || (CHECKPOINT == cell)) {
                uint32_t graph_index = maze_to_graph.size();
                /* save the current nodes mapping from maze coordinates into
                 * graph coordinates */
                maze_to_graph[maze_index] = graph_index;
                Node current_node;
                /* look for an edge to the left */
                if ( jj != 0 && maze[ii][jj-1] != WALL) {
                    uint32_t left_maze_index = maze_index - 1;
                    /* the node to the left has already been processed, so
                     * looking up its maze index should always succeed */
                    uint32_t left_graph_index = maze_to_graph[left_maze_index];
                    /* edges are bidirectional so add adjacency to the left 
                     * node and the current node */
                    current_node.edges.push_back(left_graph_index);
                    graph[left_graph_index].edges.push_back(graph_index);
                }
                /* look for an edge to the top*/
                if ( ii != 0 && maze[ii - 1][jj] != WALL) {
                    uint32_t top_maze_index = (ii - 1) * row.size() + jj;
                    /* the node to the left has already been processed, so
                     * looking up its maze index should always succeed */
                    uint32_t top_graph_index = maze_to_graph[top_maze_index];
                    /* edges are bidirectional so add adjacency to the left 
                     * node and the current node */
                    current_node.edges.push_back(top_graph_index);
                    graph[top_graph_index].edges.push_back(graph_index);
                }
                graph.push_back(current_node);
                if (CHECKPOINT == cell) {
                    checkpoints.push_back(graph_index);
                }
            } else if( WALL != cell) {
                printf("invalid cell value: %d at (%d, %d), exiting...",
                        cell, ii, jj);
                exit(1);
            }
            ++maze_index;
            ++jj;
        }
        ++ii;
    }
    return result;
}

void print_graph(std::vector<Node> &graph) {
    for(const auto& node : graph) {
        std::cout << "edges: ";
        for(auto edge : node.edges) {
            std::cout << edge << ", ";
        }
        std::cout << std::endl;
    }
}

int main() {
    uint32_t R, C, x, y;
    std::cin >> R >> C >> x >> y;
    std::vector<std::vector<uint8_t>> maze(R, std::vector<uint8_t>(C, 0));
    /* read in the maze from stdin. Expects a format of space separated
     * integers
     */
    for(uint32_t ii = 0; ii < R; ++ii) {
        for(uint32_t jj = 0; jj < C; ++jj) {
            std::cin >> maze[ii][jj];
        }
    }
    std::vector<Node> graph;
    std::vector<uint32_t> checkpoints;

    auto exits = convert_maze_to_graph(maze, 0, 0, x, y, graph, checkpoints);
    
    const uint32_t N = graph.size();
    const uint64_t MY_INFINITY = std::numeric_limits<uint64_t>::max();
    std::vector<std::vector<uint64_t>> dist(
            N,
            std::vector<uint64_t>(N, MY_INFINITY));
    /* intialize floyd-warshall adjacency matrix */
    for(uint32_t ii = 0; ii < N; ++ii) {
        dist[ii][ii] = 0;
        for(uint32_t jj : graph[ii].edges) {
            /* constant distance to travel between adjacent open maze cells */
            dist[ii][jj] = 1;
        }
    }
    /* generate the distance graph for the entire maze graph */
    for(uint32_t kk = 0; kk < N; ++kk) {
        for(uint32_t jj = 0; jj < N; ++jj) {
            for(uint32_t ii = 0; ii < N; ++ii) {
                if (dist[ii][kk] == MY_INFINITY || dist[kk][jj] == MY_INFINITY) {
                    continue;
                }
                const auto candiate_dist = dist[ii][kk] + dist[kk][jj];
                if (candiate_dist < dist[ii][jj]) {
                    dist[ii][jj] = candiate_dist;
                    dist[jj][ii] = candiate_dist;
                }
            }
        }
    }
    /* determine the size of the reduced graph, check if any checkpoints are
     * at the start or end of the maze */
    uint32_t M = checkpoints.size() + 2;
    auto tmp_it = std::find(checkpoints.begin(), checkpoints.end(), exits.first);
    if (tmp_it != checkpoints.end()) {
        --M; /* deduct the overlap */
        checkpoints.erase(tmp_it);
    }
    tmp_it =std::find(checkpoints.begin(), checkpoints.end(), exits.second); 
    if (tmp_it != checkpoints.end()) {
        --M; /* deduct the overlap */
        checkpoints.erase(tmp_it);
    }
    std::vector<std::vector<uint64_t>> reduced_dist(
            M,
            std::vector<uint64_t>(M, MY_INFINITY)); 
    /* create a shortest path matrix for only the checkpoints, start, and stop
     * nodes */
    reduced_dist[0][0] = 0;
    reduced_dist[M-1][M-1] = 0;
    reduced_dist[M-1][0] = dist[exits.second][exits.first];
    reduced_dist[0][M-1] = dist[exits.first][exits.second];
    for(uint32_t ii = 0; ii < M; ++ii) {
        reduced_dist[0][ii] = dist[exits.first][checkpoints[ii]];
        reduced_dist[ii][0] = dist[checkpoints[ii]][exits.first];
        reduced_dist[M-1][ii] = dist[exits.second][checkpoints[ii]];
        reduced_dist[ii][M-1] = dist[checkpoints[ii]][exits.second];
    }

}
