Definitions.

Int    = [0-9]+
Float  = [0-9]+\.[0-9]+
WS     = [\n\s\r\t]
Atom  = [a-z_][a-zA-Z0-9!\?_]*

Rules.

\(      : {token, {'(',    TokenLine}}.
\)      : {token, {')',    TokenLine}}.
{Int}   : {token, {number, TokenLine, int(TokenChars)}}.
{Float} : {token, {number, TokenLine, flt(TokenChars)}}.
{Atom}  : {token, {atom,   TokenLine, list_to_atom(TokenChars)}}.
{WS}    : skip_token.


Erlang code.

int(S) when is_list(S) ->
  {I, _} = string:to_integer(S),
  I.

flt(S) when is_list(S) ->
  {F, _} = string:to_float(S),
  F.
