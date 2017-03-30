defmodule Top.Server do
  use GenServer
  @big_dirty_regex ~r/.*:\s(?<total_processes>\d*)\s.*,\s(?<running_processes>\d*).*,\s(?<stuck_processes>\d*).*,\s(?<sleeping_processes>\d*)\s.*,\s(?<threads>\d*).*\n(?<date>\d*\/\d*\/\d*)\s(?<time>\d*:\d*:\d*)\n.*:\s(?<1m_load_avg>\d*\.\d*),\s(?<5m_load_avg>\d*\.\d*),\s(?<15m_load_avg>\d*\.\d*).*\n.*:\s(?<user_cpu_usage>\d*\.\d*).*,\s(?<system_cpu_usage>\d*\.\d*).*,\s(?<idle_cpu>\d*\.\d*).*\n.*:\s(?<resident_sharedlibs>\d*\w)\s.*,\s(?<data_sharedlibs>\d*\w)\s.*,\s(?<linkedit_sharedlibs>\d*\w).*\n.*:\s(?<total_memregions>\d*)\s.*,\s(?<resident_memregions>\d*\w)\s.*,\s(?<private_memregions>\d*\w)\s.*,\s(?<shared_memregions>\d*\w).*\n.*:\s(?<used_physmem>\d*\w)\s.*\s\((?<used_wired_physmem>\d*\w)\s.*\),\s(?<unused_physmem>\d*\w).*\n.*\s(?<v_size>\d*\w)\s.*\s(?<framework_vsize>\d*\w)\s.*\s.*,\s(?<swapins>\d*\(\d*\))\s.*,\s(?<swapouts>\d*\(\d*\)).*\n.*:\s(?<packets_in>\d*\/\d*\w).*.\s(?<packets_out>\d*\/\d*\w).*\n.*:\s(?<read_disks>\d*\/\d*\w).*,\s(?<written_disks>\d*\/\d*\w)\s.*/

  ## Interface
  def start_link(_) do
      GenServer.start_link(__MODULE__, nil, name: :top_server)
  end

  def report, do: GenServer.call(:top_server, {:report})

  def report(key), do: GenServer.call(:top_server, {:report, key})

  ## GenServer Implementation
  def init(_) do
    port = Port.open({:spawn, "top -n 0"}, [:binary])
    {:ok, {Map.new, port}}
  end

  def handle_call({:report}, _, {map, _port} = state) do
    {:reply, map, state}
  end

  def handle_call({:report, key}, _, {map, _port} = state) do
    value = Map.get(map, key)
    {:reply, value, state}
  end

  def handle_call({:resume}, _, _state) do
    init(nil)
  end

  def handle_info({port, {:data, payload}}, {_old_state, port}) do
    new_state = Regex.named_captures(@big_dirty_regex, payload)
    {:noreply, {new_state, port}}
  end

  def handle_info(_, state), do: {:noreply, state} 

  ## Helper/Private Functions
end