#include <iostream>
#include <cstdint>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char** argv) {
    std::string host = "127.0.0.6";

    int sde = ::socket(AF_INET, SOCK_DGRAM, 0);
    sockaddr_in sin;
    hostent* he = gethostbyname(host.c_str());
    
    std::cout << he->h_addr << std::endl;
    std::cout << he->h_length << std::endl;
    
    sin.sin_addr.s_addr = he->h_addr;
    /*
    std::copy(static_cast<char*>(he->h_addr),
              static_cast<char*>(he->h_addr) + he->h_length,
              static_cast<char*>(&sin.sin_addr.s_addr));
    sin.sin_family = AF_INET;
    sin.sin_port = htons(15000);
    */
}
