#include <stdio.h>

/*
This is a comment outside the main function
*/
void helper_function(const char *source)
{
    printf(source, 10, 34, source);
}

int main(void)
{
    /*
    This is a comment inside the main function
    */
    const char *source = "#include <stdio.h>%1$c%1$c/*%1$cThis is a comment outside the main function%1$c*/%1$cvoid helper_function(const char *source)%1$c{%1$c    printf(source, 10, 34, source);%1$c}%1$c%1$cint main(void)%1$c{%1$c    /*%1$c    This is a comment inside the main function%1$c    */%1$c    const char *source = %2$c%3$s%2$c;%1$c    helper_function(source);%1$c    return 0;%1$c}%1$c";
    helper_function(source);
    return 0;
}
