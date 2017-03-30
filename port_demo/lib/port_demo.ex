defmodule Top do
  @moduledoc """
  Interface for `top` Unix introspection. Currently this implementation only gives top-level information, and no information about OS processes.
  """

  @doc """
  `report/0` returns the current status returned from the external `top` process as a map. All keys and values are returned as strings.

  ### Example
  iex(2)> Top.report
  %{"15m_load_avg" => "2.77", "1m_load_avg" => "4.10", "5m_load_avg" => "3.19",
  "data_sharedlibs" => "30M", "date" => "2017/03/30",
  "framework_vsize" => "533M", "idle_cpu" => "77.59",
  "linkedit_sharedlibs" => "52M", "packets_in" => "548578/620M",
  "packets_out" => "335612/50M", "private_memregions" => "145M",
  "read_disks" => "421582/10G", "resident_memregions" => "5282M",
  "resident_sharedlibs" => "250M", "running_processes" => "12",
  "shared_memregions" => "1792M", "sleeping_processes" => "276",
  "stuck_processes" => "9", "swapins" => "0(0)", "swapouts" => "0(0)",
  "system_cpu_usage" => "17.83", "threads" => "1509", "time" => "14:30:16",
  "total_memregions" => "51727", "total_processes" => "297",
  "unused_physmem" => "3990M", "used_physmem" => "12G",
  "used_wired_physmem" => "1818M", "user_cpu_usage" => "4.57",
  "v_size" => "817G", "written_disks" => "98605/2960M"}  

  """
  @spec report() :: map
  def report(), do: Top.Server.report()


  @doc """
  Given a specific key, this function will return its corresponding value from `top`.

  ### Example
  iex(3)> Top.report "idle_cpu"
  "63.41"
  """
  @spec report(String.t) :: String.t
  def report(key), do: Top.Server.report(key)

end
