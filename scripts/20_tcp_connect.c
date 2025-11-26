#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <string.h>

#define BUFFER_SIZE 34


int main (int argc, char **argv)
{
    if (argc != 2) {
        printf("Usage: ./suconnect <portnumber>\n");
        printf("This program will connect to the given port on localhost using TCP.\nIf it receives the correct password from the other side, the next password is transmitted back.");
        return 1;
    }

    char next_password[BUFFER_SIZE];
    FILE* filefd = fopen("/etc/bandit_pass/bandit21", "r");
    fgets(next_password, BUFFER_SIZE, filefd);
    next_password[BUFFER_SIZE] = '\0';
    fclose(filefd);

    setreuid(geteuid(), getuid());

    char current_password[BUFFER_SIZE];
    filefd = fopen("/etc/bandit_pass/bandit20", "r");
    fgets(current_password, BUFFER_SIZE, filefd);
    current_password[BUFFER_SIZE] = '\0';
    fclose(filefd);

    //Create socket and ip+port struct
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    struct sockaddr_in serv_addr;
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(atoi(argv[1]));
    inet_aton("127.0.0.1", &serv_addr.sin_addr);

    int res = connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

    char buffer[BUFFER_SIZE];
    bzero(buffer,BUFFER_SIZE);

    int n = read(sockfd, buffer, BUFFER_SIZE);

    printf("Read: %s\n", buffer);

    if (strcmp(buffer, current_password) == 0) {
        printf("Password matches, sending next password\n");
        write(sockfd, next_password, BUFFER_SIZE);

    } else {
        printf("ERROR: This doesn't match the current password!\n");
        write(sockfd, "FAIL!\n", 6);
    }

    close(sockfd);
    return 0;
}
