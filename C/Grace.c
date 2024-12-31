#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

#define SELF "#include <stdio.h>%c#include <fcntl.h>%c#include <unistd.h>%c%c#define SELF %c%s%c%c#define PRINT(fd) dprintf(fd, SELF, 10, 10, 10, 10, 34, SELF, 34, 10, 10, 34, 34, 10, 10, 10, 10, 10, 10, 10)%c#define MAIN() int main() { int fd = open(%cGrace_kid.c%c, O_WRONLY | O_CREAT | O_TRUNC, 0644); if (fd < 0) return 1; PRINT(fd); close(fd); return 0; }%c%c/*%c  Quine using macros%c*/%c%cMAIN()%c"
#define PRINT(fd) dprintf(fd, SELF, 10, 10, 10, 10, 34, SELF, 34, 10, 10, 34, 34, 10, 10, 10, 10, 10, 10, 10)
#define MAIN() int main() { int fd = open("Grace_kid.c", O_WRONLY | O_CREAT | O_TRUNC, 0644); if (fd < 0) return 1; PRINT(fd); close(fd); return 0; }

/*
  Quine using macros
*/

MAIN()
