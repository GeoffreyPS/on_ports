# Quick and Dirty on Ports

## Why ports?
Ports are the safest way to communicate to external programs outside of the BEAM that are local to the machine. 

It can be a large time saver to re-use a solution implemented in another language instead of writing a solution from scratch in Elixir. Or possibly, Elixir isn't always the best fit for a certain use case, but may be useful for coordination, fault-tolerance, and glue between multiple programs.

A port is owned by some process and can be communicated to via message passing, very similarly to any other process. A port will communicate to an external process on your operating system through STDIN and STDOUT (by default). Because of this, it's best to favor passing large work loads to the external program and return information instead of a chatty implementation with smaller computations.

Ports are OTP compliant, so if you have a port open to a network socket or another application and you tear down part of your supervision structure, the port will be closed gracefully (on the Erlang side, more about that below).

## How does one use ports?
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

### Rules of ports
- Be sure to close ports when you're done with them with `Port.close/1`
- If the external progam exits, the port closes. If a port is closed, the function `Port.info/1` will return `nil`.
- Ports communicate through sending 2-tuples in the form of {:command, command} and {:data, data}, and can be reached with the `send/2` function from Elixir's `Kernel` module.
- `:spawn` and `:spawn_executable` are the two settings you will typically use. 
- `:spawn_executable` is more strict than `:spawn`, and requires a full file path. `:spawn` will do some favors looking in your $PATH environment, but it has some limitations. 
  - `:spawn_driver` and `:fd` are for linked-in drivers and for file descriptors used by the VM, and should be used with extreme caution and good reason.
- There are many more settings explained in the Erlang Docs.


### Implementation

### Best practices, tips, and thoughts
- Wrap your port operations in a GenServer to offer a clean API to use the external service within Elixir.

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

### Further steps

## References / Further Reading
- [Elixir Documentation](https://hexdocs.pm/elixir/Port.html)
- [Erlang Documentation](http://erlang.org/doc/man/erlang.html#open_port-2)
- [`System.cmd` implementation in Elixir](https://github.com/elixir-lang/elixir/blob/master/lib/elixir/lib/system.ex#L592)
- Saša Jurić's [guide on ports](http://theerlangelist.com/article/outside_elixir)
- [Porcelain Library](https://github.com/alco/porcelain)