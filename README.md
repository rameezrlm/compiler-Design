# React++ Lexical Analyzer

A compact lexical analyzer for **React++** — a teaching language that mixes C++-like structure with web/React-inspired keywords and punctuation.  
This repository contains the lexer (Flex) rules, build/run instructions, examples, and sample output.

---

# Quick build & run

```bash
# generate lexer C file (scanner.l is the Flex file)
flex scanner.l

# compile
gcc lex.yy.c -lfl -o reactpp_lexer

# run
./reactpp_lexer input.rpp > tokens.txt
input.rpp is a sample React++ source file. tokens.txt will contain tokenized output with line numbers.

```
# What This Lexer Does
Tokenizes React++ source into tokens with types and line numbers.
Detects and emits error tokens for:
Invalid identifiers
Invalid character literals
Unterminated strings
Skips whitespace and comments (but prints comments on console for reference).
Supports integer, float, and exponential-number formats.
Recognizes custom punctuation: </, \>, $, [: :] comments, and single-line : comments.
Token Classes & Representative Regexes
Identifiers
IDENTIFIER → @[_a-zA-Z][a-zA-Z0-9]*
Valid examples: @count, @_tmp
Numbers
INTEGER → [0-9]+
FLOAT → [0-9]*\.[0-9]+
EXP_NUMBER → [0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?
Examples: 123, 3.14, 1e-5, 3.14E+2

Literals
STRING_LITERAL → \"([^\"\n]*)\"
CHAR_LITERAL → \'[a-zA-Z0-9!@#$%^&*()_,./;’]'`

Comments

MULTI_LINE_COMMENT → \[:[^\]]*:\]

SINGLE_LINE_COMMENT → :[^=<>!~].*$

Operators & Punctuation

OUTPUT_OPERATOR → <<

INPUT_OPERATOR → >>

EQ_OPERATOR → :=

NEQ_OPERATOR → ~=

END_OF_STATEMENT → \$

BLOCK_START → </

BLOCK_END → \>

Others: ( ) , ;

Invalid / Error patterns

Invalid identifier: starts with @ + digit (e.g. @1abc)

Unterminated string: " not closed

Invalid char literal: multi-character like 'AB'
# Keywords (React++ → C++ Equivalent)

```
state    -> int
scale    -> float
tag      -> char
content  -> string
lock     -> const
detect   -> auto
toggle   -> bool
render   -> cout
fetch    -> cin
promise  -> if
deceit   -> else
navigate -> for
observe  -> while
dispatch -> do
route    -> switch
path     -> case
rerender -> continue
unmount  -> break
redirect -> goto
send     -> return
root     -> main
```

# Example React++ Source (input.rpp)
```
[: sample program :]
state root()
</
    state @x = 5$
    scale @y = 2.5$
    scale @exp = 3.14e+2$
    tag @grade = 'A'$
    content @msg = "Hello"$

    promise (@x >= 5 and @y < 100)
        render << @msg$
    deceit
        render << "Bye"$

    navigate (@i = 0; @i < 3; @i = @i + 1)
    </ render << "Loop"$ \>

    send 0$
\>

```

# Sample Tokens:
```
2  KEYWORD       state
2  KEYWORD       root
2  PUNCTUATION   (
2  PUNCTUATION   )
3  PUNCTUATION   </
5  KEYWORD       state
5  IDENTIFIER    @x
5  OPERATOR      =
5  INTEGER       5
5  END_OF_LINE   $
6  KEYWORD       scale
6  IDENTIFIER    @y
6  OPERATOR      =
6  FLOAT         2.5
6  END_OF_LINE   $
7  KEYWORD       scale
7  IDENTIFIER    @exp
7  OPERATOR      =
7  EXP_NUMBER    3.14e+2
7  END_OF_LINE   $
8  KEYWORD       tag
8  IDENTIFIER    @grade
8  OPERATOR      =
8  CHAR          'A'
8  END_OF_LINE   $
9  KEYWORD       content
9  IDENTIFIER    @msg
9  OPERATOR      =
9  STRING        "Hello"
9  END_OF_LINE   $
11 INVALID_IDENTIFIER @1invalid
11 OPERATOR           =
11 INTEGER            99
11 END_OF_LINE        $
12 INVALID_CHAR       'AB'
13 UNTERMINATED_STRING "Unclosed string
```
# Error Handling Policy

Every unrecognized lexeme emits an ERROR token with line number and raw text.

Error categories:

INVALID_IDENTIFIER — identifier starts with digit after @

INVALID_CHAR — multi-character char literals

UNTERMINATED_STRING — string not closed before newline or EOF

All errors are printed and written to tokens.txt.

# Contribution

Keep regex rules clean and minimal.

Add more keywords or operators if React++ evolves.

Create test files like test_*.rpp and test lexer output consistency.
