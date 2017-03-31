# Top
Elixir wrapper for Top, example project for using ports.


## Installation

```sh
## clone the repository
git@github.com:GeoffreyPS/on_ports.git

## navigate to the mix project
cd port_demo

## run the REPL
iex -S mix
```


## Usage
The application has two functions: `Top.report/0` and `Top.report/1`. 
The 0 arity version will return a map with the current high-level information reported from Top. The single arity version accepts a key name as a string, and returns the value. 

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/port_demo](https://hexdocs.pm/port_demo).

