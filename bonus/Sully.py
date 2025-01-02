import os
X: int = 5
SELF: str = "import os{0}X: int = {3}{0}SELF: str = {1}{2}{1}{0}PRINT: callable = lambda: open('Sully_{{}}.py'.format(X-1), 'w').write(SELF.format(chr(10), chr(34), SELF, X-1)){0}MAIN: callable = lambda: (PRINT() and os.system('python3 Sully_{{}}.py'.format(X-1)) if X > 0 else None){0}{0}MAIN(){0}"
PRINT: callable = lambda: open('Sully_{}.py'.format(X-1), 'w').write(SELF.format(chr(10), chr(34), SELF, X-1))
MAIN: callable = lambda: (PRINT() and os.system('python3 Sully_{}.py'.format(X-1)) if X > 0 else None)

MAIN()