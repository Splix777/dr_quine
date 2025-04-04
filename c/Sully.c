#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

#define X 5
#define SELF "#include <stdio.h>%1$c#include <fcntl.h>%1$c#include <unistd.h>%1$c#include <stdlib.h>%1$c%1$c#define X %4$d%1$c#define SELF %2$c%3$s%2$c%1$c#define PRINT(fd, x) dprintf(fd, SELF, 10, 34, SELF, x)%1$c#define MAIN()%1$c    int main()%1$c    {%1$c        int x = X;%1$c        char filename[20], execname[20], command[100];%1$c        if (x < 0) return 0;%1$c        snprintf(filename, sizeof(filename), %2$cSully_%%d.c%2$c, x);%1$c        snprintf(execname, sizeof(execname), %2$cSully_%%d%2$c, x);%1$c        int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644);%1$c        if (fd < 0) return 1;%1$c        PRINT(fd, x - 1);%1$c        close(fd);%1$c        snprintf(command, sizeof(command), %2$cgcc -Wall -Wextra -Werror -o %%s %%s%2$c, execname, filename);%1$c        system(command);%1$c        snprintf(command, sizeof(command), %2$c./%%s%2$c, execname);%1$c        system(command);%1$c        return 0;%1$c    }%1$c%1$c/*%1$c  Sully: Self-replicating program%1$c*/%1$c%1$cMAIN()%1$c"
#define PRINT(fd, x) dprintf(fd, SELF, 10, 34, SELF, x)
#define MAIN()
    int main()
    {
        int x = X;
        char filename[20], execname[20], command[100];
        if (x < 0) return 0;
        snprintf(filename, sizeof(filename), "Sully_%d.c", x);
        snprintf(execname, sizeof(execname), "Sully_%d", x);
        int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (fd < 0) return 1;
        PRINT(fd, x - 1);
        close(fd);
        snprintf(command, sizeof(command), "gcc -Wall -Wextra -Werror -o %s %s", execname, filename);
        system(command);
        snprintf(command, sizeof(command), "./%s", execname);
        system(command);
        return 0;
    }

/*
  Sully: Self-replicating program
*/

MAIN()