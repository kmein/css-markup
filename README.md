# css-markup
A markup language with CSS-like syntax

## Grammar

```
expr       ::= tag, {spec}, '{', {expr}, '}'

tag        ::= ident

spec       ::= class | id | attr

class      ::= '.', ident
id         ::= '#', ident
attr       ::= ':', ident, '=', str

string     ::= '"', any character \ '"', '"'
ident      ::= ident_char, {ident_char}
ident_char ::= alnum | '-' | '_'

```
