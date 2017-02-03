Nonterminals
expressions expression literal
fn_arguments call_arguments.

Terminals
'+' '-' '<'
'{' '}' '(' ')'
'|' ','
number
true false
atom
let '='
if else.

Rootsymbol expressions.

Left 300 '+'.
Left 300 '-'.
Right 100 '<'.

expressions -> expression             : mk_block('$1').
expressions -> expression expressions : mk_block('$1', '$2').

expression -> literal                     : '$1'.
expression -> atom                        : mk_variable('$1').
expression -> expression '-' expression   : mk_subtract('$1', '$3').
expression -> expression '+' expression   : mk_add('$1', '$3').
expression -> expression '<' expression   : mk_less_than('$1', '$3').
expression -> let atom '=' expression     : mk_let('$2', '$4').
expression -> atom '(' call_arguments ')' : mk_call('$1', '$3').

% if (x) { 1 } else { 2 }
expression -> if expression '{' expressions '}'
                       else '{' expressions '}' : mk_if('$2', '$4', '$8').

% |x, y| { x + y }
expression -> '|' fn_arguments '|'
              '{' expressions '}' : mk_function('$2', '$5').

call_arguments -> expression                    : mk_call_arguments('$1', []).
call_arguments -> expression ',' call_arguments : mk_call_arguments('$1', '$3').

fn_arguments -> atom                  : mk_fn_arguments('$1', []).
fn_arguments -> atom ',' fn_arguments : mk_fn_arguments('$1', '$3').

literal -> number : mk_number('$1').
literal -> true   : mk_true('$1').
literal -> false  : mk_false('$1').

Erlang code.

mk_call({atom, _, Name}, Arguments) ->
  'Elixir.Soup.AST.Call':new(Name, Arguments).

mk_variable({atom, _, Name}) ->
  'Elixir.Soup.AST.Variable':new(Name).

mk_function(Arguments, Body) ->
  'Elixir.Soup.AST.Function':new(Arguments, Body).

mk_call_arguments(First, Rest) ->
  [First|Rest].

mk_fn_arguments({atom, _, Name}, Rest) ->
  [Name|Rest].

mk_block(Expr) ->
  'Elixir.Soup.AST.Block':new([Expr]).

mk_block(Expr, Block) ->
  #{expressions := Exprs} = Block,
  'Elixir.Soup.AST.Block':new([Expr|Exprs]).

mk_number({number, _Line, Number}) ->
  'Elixir.Soup.AST.Number':new(Number).

mk_true({true, _Line}) ->
  'Elixir.Soup.AST.True':new().

mk_false({false, _Line}) ->
  'Elixir.Soup.AST.False':new().

mk_add(X, Y) ->
  'Elixir.Soup.AST.Add':new(X, Y).

mk_subtract(X, Y) ->
  'Elixir.Soup.AST.Subtract':new(X, Y).

mk_less_than(X, Y) ->
  'Elixir.Soup.AST.LessThan':new(X, Y).

mk_if(Pred, X, Y) ->
  'Elixir.Soup.AST.If':new(Pred, X, Y).

mk_let({atom, _, Name}, Value) ->
  'Elixir.Soup.AST.Let':new(Name, Value).
