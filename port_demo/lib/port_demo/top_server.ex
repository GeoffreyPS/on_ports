defmodule Top.Server do
  use GenServer

#  @regex ~r/.*:\s(?<total_processes>\d*)\s.*,\s(?<running_processes>\d*).*,\s(?<stuck_processes>\d*).*,\s(?<sleeping_processes>\d*)\s.*,\s(?<threads>\d*).*\\n(?<date>\d*/\d*/\d*)\s(?<time>\d*:\d*:\d*)\\n.*:\s(?<1m_load_avg>\d*\.\d*),\s(?<5m_load_avg>\d*\.\d*),\s(?<15m_load_avg>\d*\.\d*).*\\n.*:\s(?<user_cpu_usage>\d*\.\d*).*,\s(?<system_cpu_usage>\d*\.\d*).*,\s(?<idle_cpu>\d*\.\d*).*\\n.*:\s(?<resident_sharedlibs>\d*\w)\s.*,\s(?<data_sharedlibs>\d*\w)\s.*,\s(?<linkedit_sharedlibs>\d*\w).*\\n.*:\s(?<total_memregions>\d*)\s.*,\s(?<resident_memregions>\d*\w)\s.*,\s(?<private_memregions>\d*\w)\s.*\s(?<shared_memregions>\d*\w).*\\n.*\s(?<used_physmem>\d*\w)\s.*\s\((?<used_wired_physmem>\d*\w)\s.*\),\s(?<unused_physmem>\d*\w).*\\n.*\s(?<v_size>\d*\w)\s.*\s(?<framework_vsize>\d*\w)\s.*\s.*,\s(?<swapins>\d*\(\d*\))\s.*,\s(?<swapouts>\d*\(\d*\)).*\\n.*packets:\s(?<packets_in>\d*\/\d*\w).*.\s(?<packets_out>\d*\/\d*\w).*\\n.*:\s(?<read_disks>\d*\/\d*\w).*,\s(?<written_disks>\d*\/\d*\w)/
  ### Notes and snippits
  ## Port.open({:spawn, "top -n 0"}, [:binary])
end