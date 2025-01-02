<h1 align="center">Dr_Quine</h1>
<h2 align="center">Ouroboros</h2>

<div align="center">
<img src="docs/readme_images/ouroboros.png" alt="Ouroboros" width="25%">
</div>

# Table of Contents
- [The Recursion Theorem of Kleene](#the-recursion-theorem-of-kleene)
- [Colleen](#colleen)
- [Grace](#grace)
- [Sully](#sully)
- [Instructions](#instructions)
- [Bonus](#bonus)

# The Recursion Theorem of Kleene

A quine is a computer program whose output and source code are identical. It's both a challenge and an interesting exploration into self-reference in programming. Here, we delve into this concept with three distinct programs, each exploring different aspects of quines.

## Colleen

**Importance:** Colleen serves as an introduction to quines by requiring you to write a program that prints its own source code. This is fundamental in understanding how programs can be self-referential.

- **Executable Name:** `Colleen`
- **Language:** C & Assembly
- **Functionality:**
  - Displays its source code on standard output when executed.
  - Must include at least one main function, two different comments (one inside main), and another function.

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:26 .
drwxr-xr-x 4 root root 4096 Feb 2 13:26 ..
-rw-r--r-- 1 root root 647 Feb 2 13:26 Colleen.c
$> clang -Wall -Wextra -Werror -o Colleen Colleen.c; ./Colleen > tmp_Colleen ; diff tmp_Colleen Colleen.c
$> _
```

## Grace

**Importance:** Grace extends the concept by writing its source to another file, emphasizing the use of macros and the absence of a traditional main function. This introduces more complex macro usage and file operations.

- **Executable Name:** `Grace`
- **Language:** C & Assembly
- **Functionality:**
  - Writes its source code to `Grace_kid.c` or `Grace_kid.s`.
  - Uses only macros (no main declared), three defines, and one comment.
  - Execution through a macro call.

```bash
$> ls -al
total 12
drwxr-xr-x 2 root root 4096 Feb 2 13:30 .
drwxr-xr-x 4 root root 4096 Feb 2 13:29 ..
-rw-r--r-- 1 root root 362 Feb 2 13:30 Grace.c
$> clang -Wall -Wextra -Werror -o Grace Grace.c; ./Grace ; diff Grace.c Grace_kid.c
```

## Sully

**Importance:** Sully takes self-replication to another level with recursive generation, where each run creates a new program that runs itself, decrementing an integer until it reaches zero. This showcases recursion, file handling, and program spawning.

- **Executable Name:** `Sully`
- **Language:** C & Assembly
- **Functionality:**
  - Writes a file `Sully_X.c` or `Sully_X.s` where X decreases with each iteration.
  - Compiles and runs the newly created file if X >= 0.
  - No constraints on source code except for the decrementing integer starting at 5.

```bash
$> clang -Wall -Wextra -Werror ../Sully.c -o Sully ; ./ Sully
$> ls -al | grep Sully | wc -l
13
```

## Conclusion

This project not only challenges your understanding of code execution and self-reference but also introduces you to advanced macro usage and assembly programming in C. Remember, directly reading and displaying source code or using command-line arguments are considered cheating in this context. Enjoy the journey into the heart of programming with Dr_Quine!

# Instructions

## Cloning the Repository

To get started with `Dr_Quine`, clone the repository:

```bash
git clone https://github.com/Splix777/dr_quine.git
cd dr_quine
```

## Using Docker
This project includes a Docker setup to ensure consistent development environments. Here's how to use it:

- **Docker Commands**
    - Build the Docker Image:
    ```bash
    make build
    ```
    - Start the Docker Container
    ```bash
    make up
    ```
    - Stop the Container
    ```bash
    make down
    ```
    - Clean Up (remove containers, volumes and prune Docker)
    ```bash
    make clean
    ```
    - Build and enter the container all done with a simple make
    ```bash
    make
    ```

# Bonus
The only Bonus accepted during the evaluation is to have redone this project entirely in the language of your choice. In my case I have chosen python. This is located in the bonus dir with it's corresponding Makefile.