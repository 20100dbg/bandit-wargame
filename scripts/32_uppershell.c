#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BUFFERSIZE 1023


int main (int argc, char **argv)
{
	setreuid(geteuid(), getuid());
	
	char *cmd = calloc(BUFFERSIZE, BUFFERSIZE), buffer[BUFFERSIZE];
	puts("__PLACEHOLDER__\n\n");
	puts("WELCOME TO THE UPPERCASE SHELL");
	
	while (1)
	{
		printf(">> ");
		fgets(cmd, BUFFERSIZE, stdin);
		
		int count = strlen(cmd);

		for (int i = 0; i < count; i++)
		{
			cmd[i] = toupper(cmd[i]);
		}


	    system(cmd);
	}

	free(cmd);
    return 0;   
}