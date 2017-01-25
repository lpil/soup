# Soup

Soup is a simple interpreted language, the runtime for which is written in
Elixir.

```rust
let x = 1
let y = 2

let z = if (x > y) {
  true
} else {
  false
}
```


It's largely an adaption of the Simple language from the first few chapters of
Tom Stuart's excellent [Understanding Computation][book].
Go grab a copy.

[book]: http://computationbook.com/

## Usage

```sh
# Compile the interpreter
mix escript.build

# Run some Souper code!
./soup priv/code/addition.soup
```

### MPL2 Licence
