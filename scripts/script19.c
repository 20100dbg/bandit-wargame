#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *concatenate(size_t size, char *array[size]){
    size_t lens[size];
    size_t i, total_size = (size-1) * 1 + 1;
    char *result, *p;

    for(i=1;i<size;++i){
        total_size += (lens[i]=strlen(array[i]));
    }
    p = result = malloc(total_size);
    for(i=1;i<size;++i){
        memcpy(p, array[i], lens[i]);
        p += lens[i];
        if(i<size-1){
            memcpy(p, " ", 1);
            p += 1;
        }
    }
    *p = '\0';
    return result;
}


int main (int argc, char **argv)
{
    if (argc == 1) {
        printf("Run a command as another user.\n   Example: ./bandit20-do id\n", argv[0]);
    }

    setreuid(geteuid(), getuid());

    char *cmd = concatenate(argc, argv);
    system(cmd);
    return 0;   
}