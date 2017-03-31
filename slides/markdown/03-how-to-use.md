### Usage

```elixir
iex(1)> port = Port.open({:spawn, "cat"}, [:binary])
#Port<0.1169>

iex(2)> send port, {self(), {:command, "SUP?"}}
{#PID<0.80.0>, {:command, "SUP?"}}

iex(3)> send port, {self(), {:command, "See ya!"}}
{#PID<0.80.0>, {:command, "See ya!"}}

iex(4)> flush()
{#Port<0.1169>, {:data, "SUP?"}}
{#Port<0.1169>, {:data, "See ya!"}}
:ok

iex(5)> send port, {self(), :close}
{#PID<0.80.0>, :close}
```