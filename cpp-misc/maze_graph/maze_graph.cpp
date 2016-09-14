#include <vector>
#include <iostream>
#include <cstdint>
#include <map>

struct Node {
    Node() : distance(0) {}

    std::vector<uint32_t> edges;
    uint32_t distance;
};

void convert_maze_to_graph(std::vector<std::vector<uint8_t>> &maze,
                      std::vector<Node> &graph,
                      std::vector<uint32_t> &checkpoints)
{
    graph.clear();
    checkpoints.clear();

    std::map<uint32_t, uint32_t> maze_to_graph;    
    const uint8_t WALL = '1';
    const uint8_t SPACE = '0';
    const uint8_t CHECKPOINT = '2';
    uint32_t ii = 0, jj = 0;
    uint32_t maze_index = 0;
    for(const auto& row : maze) {
        jj = 0;
        for(const auto cell : row) {
            if ((SPACE == cell) || (CHECKPOINT == cell)) {
                uint32_t graph_index = graph.size();
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

    convert_maze_to_graph(maze, graph, checkpoints);
    for(const auto& node : graph) {
        std::cout << "edges: ";
        for(auto edge : node.edges) {
            std::cout << edge << ", ";
        }
        std::cout << std::endl;
    }
}
