Nonterminals
expressions expression literal.

Terminals
'+' '<'
'{' '}' '(' ')'
number
true false
atom
let '='
if else.

Rootsymbol expressions.

Left 300 '+'.
Right 100 '<'.

expressions -> expression             : mk_block(['$1']).
expressions -> expression expressions : mk_block(['$1'|'$2']).

expression -> literal                   : '$1'.
expression -> expression '+' expression : mk_add('$1', '$3').
expression -> expression '<' expression : mk_less_than('$1', '$3').
expression -> let atom '=' expression   : mk_let('$2', '$4').
expression -> if '(' expression ')'
              '{' expression '}'
              else '{' expression '}'   : mk_if('$3', '$6', '$10').

literal -> number : mk_number('$1').
literal -> true   : mk_true('$1').
literal -> false  : mk_false('$1').

Erlang code.

mk_block(Exprs) ->
  'Elixir.Soup.AST.Block':new(Exprs).

mk_number({number, _Line, Number}) ->
  'Elixir.Soup.AST.Number':new(Number).

mk_true({true, _Line}) ->
  'Elixir.Soup.AST.True':new().

mk_false({false, _Line}) ->
  'Elixir.Soup.AST.False':new().

mk_add(X, Y) ->
  'Elixir.Soup.AST.Add':new(X, Y).

mk_less_than(X, Y) ->
  'Elixir.Soup.AST.LessThan':new(X, Y).

mk_if(Pred, X, Y) ->
  'Elixir.Soup.AST.If':new(Pred, X, Y).

mk_let({atom, _, Name}, Value) ->
  'Elixir.Soup.AST.Let':new(Name, Value).
