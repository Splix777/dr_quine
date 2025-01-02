# This is a comment outside of the main function

def quine() -> None:
    # This is a comment inside the quine function
    s = "# This is a comment outside of the main function{0}{0}def quine() -> None:{0}    # This is a comment inside the quine function{0}    s = {1}{2}{1}{0}    print(s.format(chr(10), chr(34), s)){0}{0}{0}def main() -> None:{0}    quine(){0}{0}{0}if __name__ == {1}__main__{1}:{0}    main()"
    print(s.format(chr(10), chr(34), s))


def main() -> None:
    quine()


if __name__ == "__main__":
    main()
