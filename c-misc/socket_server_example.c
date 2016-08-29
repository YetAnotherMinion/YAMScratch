#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> /*for read and write*/
#include <sys/types.h>
#include <sys/socket.h>
#include <errno.h>
#include <string.h>
/*gives you htons() */
#include <arpa/inet.h>
/*gives you bzero */
#include <strings.h>
/*gives concurrency*/
/* commented out to get travis working quicker
#include <mpi.h>
*/
/*locally defined files */
#include "chunks.h"
#include "ellipsoid.h"

int main(int argc, char *argv[])
{
	if(argc != 3) {
		printf("Usage: %s <address> <port>\n",argv[0]);
	}
	int socketfd;
	int newsockfd;
	int portno;
	socklen_t client_length;
	struct sockaddr_in server_addr;
	struct sockaddr_in client_addr;
	int n;
	char buffer[256];

	/*open the socket */
	socketfd = socket(AF_INET, SOCK_STREAM, 0);
	/*ckeck that the socket is valid */
	if(socketfd < 0) {
		printf("Error in socket creation\n");
		exit(1);
	}
	bzero((char *) &server_addr, sizeof(server_addr));
	portno = atoi(argv[2]);
	server_addr.sin_family = AF_INET;
	/*add the ip address of the socket */
	/*server_addr.sin_addr.s_addr = INADDR_ANY; */
	server_addr.sin_addr.s_addr = inet_addr(argv[1]);
	/*convert the bost byte order and network byte order with htons() */
	server_addr.sin_port = htons(portno);
	/*we will need to recast the sockaddr_in struct to general */
	/*type sockaddr */
	if( bind(socketfd, (const struct sockaddr *) &server_addr, sizeof(server_addr)) < 0 ) {
		printf("error in binding\n");
		exit(1);
	}
	/*start listening for clients */
	printf("Listening for clients\n");
	listen(socketfd,5);
	client_length = sizeof(client_addr);

	/*accept a new connection from the client */
	newsockfd = accept(socketfd, (struct sockaddr *) &client_addr, &client_length);
	if(newsockfd < 0) {
		perror("ERROR on accept");
		exit(1);
	}
	printf("Connected to: %s:%d\n",inet_ntoa(client_addr.sin_addr),client_addr.sin_port);
	bzero(buffer,256);
	strncpy(buffer,"Welcome to one off chat client:\n",255);
	n = write(newsockfd, buffer, strlen(buffer));

	if(n < 0) {
		perror("ERROR writing to socket");
		exit(1);
	}

	bzero(buffer,256);
	n = read(newsockfd, buffer, 255);
	/*check that messages were actually read from the socket*/
	if(n < 0) {
		perror("ERROR reading from socket\n");
		exit(1);
	}

	printf("This is the message: \n %s", buffer);

	n = write(newsockfd, "I got your message",18);

	if(n < 0) {
		perror("ERROR writing to socket");
		exit(1);
	}

	n = close(newsockfd);
	n = close(socketfd);

	printf("Hello from server\n");
	return 0;
}
