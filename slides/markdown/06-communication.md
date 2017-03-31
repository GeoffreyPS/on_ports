## Communication
- Ports communicate through sending 2-tuples in the form of {:command, command} and {:data, data}
- Can be reached with the `send/2` function from Elixir's `Kernel` module or from `Port.command/3`