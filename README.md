# Primer on Ports

## Preface
The project is divided into two main directories: `port_demo/` for an implementation with a GenServer, and `slides/` for running the reveal.js presentation. See below in this readme for a guide on ports. 

## Why ports?
Ports are the safest way to communicate to external programs outside of the BEAM that are local to the machine. 

It can be a large time saver to re-use a solution implemented in another language instead of writing a solution from scratch in Elixir. Or possibly, Elixir isn't always the best fit for a certain use case, but may be useful for coordination, fault-tolerance, and glue between multiple programs.

A port is owned by some process and can be communicated to via message passing, very similarly to any other process. A port will communicate to an external process on your operating system through STDIN and STDOUT (by default). Because of this, it's best to favor passing large work loads to the external program and return information instead of a chatty implementation with smaller computations.

Ports are OTP compliant, so if you have a port open to a network socket or another application and you tear down part of your supervision structure, the port will be closed gracefully (on the Erlang side, more about that below).


## Usage
Elixir has a `Port` module, which is merely a thin wrapper around Erlang's port BIFs.

To open a port, simply use the command `Port.open/2`: 
```elixir
iex(11)> port = Port.open({:spawn, "whoami"}, [:binary])
#Port<0.1267>
iex(12)> flush()
{#Port<0.1267>, {:data, "geoff\n"}}
:ok
iex(13)> Port.info port
nil
iex(14)> cat_port = Port.open({:spawn, "cat"}, [:binary])
#Port<0.1268>
iex(15)> send cat_port, {self(), {:command, "Hello from port!"}}
{#PID<0.80.0>, {:command, "Hello from port!"}}
iex(16)> send cat_port, {self(), {:command, "Goodbye from port!"}}
{#PID<0.80.0>, {:command, "Goodbye from port!"}}
iex(17)> flush()
{#Port<0.1268>, {:data, "Hello from port!"}}
{#Port<0.1268>, {:data, "Goodbye from port!"}}
:ok
iex(18)> Port.info cat_port
[name: 'cat', links: [#PID<0.80.0>], id: 10144, connected: #PID<0.80.0>,
 input: 34, output: 34, os_pid: 2064]
iex(19)> send cat_port, {self(), :close}
{#PID<0.80.0>, :close}
iex(20)> flush()
{#Port<0.1268>, :closed}
:ok
iex(21)> Port.info cat_port
nil
```


### Other functions
- Be sure to close ports when you're done with them with `Port.close/1`
- If the external progam exits, the port closes. If a port is closed, the function `Port.info/1` will return `nil`.
- Ports communicate through sending 2-tuples in the form of {:command, command} and {:data, data}, and can be reached with the `send/2` function from Elixir's `Kernel` module or from `Port.command/3`.
- `:spawn` and `:spawn_executable` are the two settings you will typically use when opening a port. 
- `:spawn_executable` is more strict than `:spawn`, and requires a full file path. `:spawn` will do some favors looking in your $PATH environment, but it has some limitations. 
  - `:spawn_driver` and `:fd` are for linked-in drivers and for file descriptors used by the VM, and should be used with extreme caution and good reason.
- There are many more settings explained in the Erlang Docs.
- The process that owns the port connection can transfer its ownership to another process by sending `{self(), {:connect, new_pid}` to the port.


### Implementation
When wrapping a port in a GenServer, there are a few things to add:
- Code for opening the port.
  + I like to include this in the GenServer's `init` function if you're going to have a relationship between your process and external program. 
  + You would probably want to carry this port identifier with the GenServer's State.
```elixir
def init(_) do
    port = Port.open({:spawn, "cmd args"}, [:binary])
    ## do some other stuff if necessary
    {:ok, {initial_state, port}}
  end
```

- Code for listening/receiving messages on the port:
```elixir
  def handle_info({port, {:data, payload}}, {_old_state, port}) do
    ## do some work here
    {:noreply, {new_state, port}}
  end
```

Check the `/port_demo` directory for a quick implementation of a port wrapped in a GenServer. The key stuff here is included in `top_server.ex`. While this is a contrived example, it should give the basics on how this work on the Elixir/Erlang side.


#### Note:
This is a contrived example of wrapping a Unix OS program in a port. If you are simply getting information from a program and reporting back its return result, please use [`System.cmd/3`](https://hexdocs.pm/elixir/System.html#cmd/3) instead. You will save yourself a lot of time. This function also uses ports to fetch information, and it's worthwhile to look at the implementation.


### Best practices, tips, and thoughts
- Wrap your port operations in a GenServer to offer a clean API to use the external service within Elixir.

- You can communicate to a port on [3] and [4] instead of STDIN/STDOUT by setting `:nouse_stio` in the list of settings to `Port.open/2`. This is helpful if you want to print information to STDIN/STOUT and not have Erlang catch all of printed messages (say, for debugging).

- If you don't know how your external program will close down, it's a good practice to wrap the command in a bash script. Below is the example from Elixir's recommendation on preventing [Zombie Processes](https://hexdocs.pm/elixir/Port.html#module-zombie-processes).
```bash
#!/bin/sh
"$@"
pid=$!
while read line ; do
  :
done
kill -KILL $pid
```

- The data passed between the two programs will be strings or lists of bytes, but can be serialized through something like JSON or whatever lowest common denomenator you have chosen for your project. Additionally, there are language-specific libraries that can convert Erlang terms within the program so you can send/receive messages with `:erlang.term_to_binary/1` and `:erlang.binary_to_term/1`. 


## References / Further Reading
- [Elixir Documentation](https://hexdocs.pm/elixir/Port.html)
- [Erlang Documentation](http://erlang.org/doc/man/erlang.html#open_port-2)
- [`System.cmd` implementation in Elixir](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/system.ex#L592)
- Saša Jurić's [guide on ports](http://theerlangelist.com/article/outside_elixir)
- [Porcelain Library](https://github.com/alco/porcelain)