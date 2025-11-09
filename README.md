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

