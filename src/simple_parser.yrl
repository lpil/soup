Nonterminals
expressions expression literal.

Terminals
'+' '<'
'{' '}' '(' ')'
number
true false
if else.

Rootsymbol expressions.

Left 300 '+'.
Right 100 '<'.

expressions -> expression             : ['$1'].
expressions -> expression expressions : ['$1'|'$2'].

expression -> literal                   : '$1'.
expression -> expression '+' expression : mk_add('$1', '$3').
expression -> expression '<' expression : mk_less_than('$1', '$3').
expression -> if '(' expression ')'
              '{' expression '}'
              else '{' expression '}'   : mk_if('$3', '$6', '$10').

literal -> number : mk_number('$1').
literal -> true   : mk_true('$1').
literal -> false  : mk_false('$1').

Erlang code.

mk_number({number, _Line, Number}) ->
  'Elixir.Simple.AST.Number':new(Number).

mk_true({true, _Line}) ->
  'Elixir.Simple.AST.True':new().

mk_false({false, _Line}) ->
  'Elixir.Simple.AST.False':new().

mk_add(X, Y) ->
  'Elixir.Simple.AST.Add':new(X, Y).

mk_less_than(X, Y) ->
  'Elixir.Simple.AST.LessThan':new(X, Y).

mk_if(Pred, X, Y) ->
  'Elixir.Simple.AST.If':new(Pred, X, Y).
