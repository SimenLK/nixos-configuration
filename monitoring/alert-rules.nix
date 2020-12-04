{ lib }:
with lib;

let
  deviceFilter = ''fstype!="ramfs",device!="rpc_pipefs",device!="lxcfs",device!="nsfs",device!="borgfs"'';
in mapAttrsToList (name: opts: {
  alert = name;
  expr = opts.condition;
  for = opts.time or "2m";
  labels = if (opts.page or true) then { severity = "page"; } else {};
  annotations = {
    summary = opts.summary;
    description = opts.description;
  };
}) {
  # node_deployed = {
  #   condition = "node_deployed < time()-86400*14";
  #   page = false;
  #   summary = "{{$labels.alias}}: Last deployed on {{$labels.date}} with version {{$labels.version}}";
  #   description = "{{$labels.alias}}: Last deployed on {{$labels.date}} with version {{$labels.version}}";
  # };
  node_down = {
    condition = ''up{job="node"} == 0'';
    summary = "{{$labels.alias}}: Node is down.";
    description = "{{$labels.alias}} has been down for more than 2 minutes.";
  };
  node_collector_failed = {
    condition = ''node_scrape_collector_success{job="node"} == 0'';
    summary = "{{$labels.alias}}: Node collector {{$labels.collector}} failed.";
    description = "{{$labels.alias}}: The collector {{$labels.collector}} of node exporter instance {{$labels.instance}} failed.";
  };
  node_systemd_service_failed = {
    condition = ''node_systemd_unit_state{state="failed"} == 1'';
    summary = "{{$labels.alias}}: Service {{$labels.name}} failed to start.";
    description = "{{$labels.alias}} failed to (re)start service {{$labels.name}}.";
  };
  # node_filesystem_full_80percent = {
  #   condition = ''sort(node_filesystem_free_bytes{${deviceFilter}} < node_filesystem_size_bytes{${deviceFilter}} * 0.2) / 1024^3'';
  #   time = "10m";
  #   summary = "{{$labels.alias}}: Filesystem is running out of space soon.";
  #   description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} got less than 20% space left on its filesystem.";
  # };
  # node_filesystem_full_in_7d = {
  #   condition = ''node_filesystem_free_bytes{${deviceFilter}} ''
  #     + ''and predict_linear(node_filesystem_free_bytes{${deviceFilter}}[2d], 7*24*3600) <= 0'';
  #   time = "1h";
  #   summary = "{{$labels.alias}}: Filesystem is running out of space in 7 days.";
  #   description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of space in approx. 7 days";
  # };
  # node_filesystem_full_in_30d = {
  #   condition = ''node_filesystem_free_bytes{${deviceFilter}} ''
  #     + ''and predict_linear(node_filesystem_free_bytes{${deviceFilter}}[30d], 30*24*3600) <= 0'';
  #   time = "1h";
  #   summary = "{{$labels.alias}}: Filesystem is running out of space in 30 days.";
  #   description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of space in approx. 30 days";
  # };
  # node_inodes_full_in_7d = {
  #   condition = ''node_filesystem_files_free{${deviceFilter}} ''
  #     + ''and predict_linear(node_filesystem_files_free{${deviceFilter}}[2d], 7*24*3600) < 0'';
  #   time = "1h";
  #   summary = "{{$labels.alias}}: Filesystem is running out of inodes in 7 days.";
  #   description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of inodes in approx. 7 days";
  # };
  # node_inodes_full_in_30d = {
  #   condition = ''node_filesystem_files_free{${deviceFilter}} ''
  #     + ''and predict_linear(node_filesystem_files_free{${deviceFilter}}[30d], 30*24*3600) < 0'';
  #   time = "1h";
  #   summary = "{{$labels.alias}}: Filesystem is running out of inodes in 30 days.";
  #   description = "{{$labels.alias}} device {{$labels.device}} on {{$labels.mountpoint}} is running out of inodes in approx. 30 days";
  # };
  # node_filedescriptors_full_in_3h = {
  #   condition = ''node_filefd_allocated ''
  #     + ''and predict_linear(node_filefd_allocated[3h], 3*3600) >= node_filefd_maximum'';
  #   time = "20m";
  #   summary = "{{$labels.alias}} is running out of available file descriptors in 3 hours.";
  #   description = "{{$labels.alias}} is running out of available file descriptors in approx. 3 hours";
  # };
  # node_filedescriptors_full_in_7d = {
  #   condition = ''node_filefd_allocated ''
  #     + ''and predict_linear(node_filefd_allocated[7d], 7*24*3600) >= node_filefd_maximum'';
  #   time = "1h";
  #   summary = "{{$labels.alias}} is running out of available file descriptors in 7 days.";
  #   description = "{{$labels.alias}} is running out of available file descriptors in approx. 7 days";
  # };
  node_load15 = {
    condition = ''node_load15 / on(alias) count(node_cpu_seconds_total{mode="system"}) by (alias) >= 1.0'';
    time = "10m";
    summary = "{{$labels.alias}}: Running on high load: {{$value}}";
    description = "{{$labels.alias}} is running with load15 > 1 for at least 5 minutes: {{$value}}";
  };
  node_ram_using_90percent = {
    condition =  "node_memory_MemFree_bytes + node_memory_Buffers_bytes + node_memory_Cached_bytes < node_memory_MemTotal_bytes * 0.1";
    time = "1h";
    summary = "{{$labels.alias}}: Using lots of RAM.";
    description = "{{$labels.alias}} is using at least 90% of its RAM for at least 1 hour.";
  };
  # node_swap_using_30percent = {
  #   condition = "node_memory_SwapTotal_bytes - (node_memory_SwapFree_bytes + node_memory_SwapCached_bytes) > node_memory_SwapTotal_bytes * 0.3";
  #   time = "30m";
  #   summary = "{{$labels.alias}}: Using more than 30% of its swap.";
  #   description = "{{$labels.alias}} is using 30% of its swap space for at least 30 minutes.";
  # };
  node_hwmon_temp = {
    condition = "node_hwmon_temp_celsius > node_hwmon_temp_crit_celsius*0.9 OR node_hwmon_temp_celsius > node_hwmon_temp_max_celsius*0.95";
    time = "5m";
    summary = "{{$labels.alias}}: Sensor {{$labels.sensor}}/{{$labels.chip}} temp is high: {{$value}} ";
    description = "{{$labels.alias}} reports hwmon sensor {{$labels.sensor}}/{{$labels.chip}} temperature value is nearly critical: {{$value}}";
  };
  node_reboot = {
    condition = "time() - node_boot_time_seconds < 300";
    summary = "{{$labels.alias}}: Reboot";
    description = "{{$labels.alias}} just rebooted.";
  };
  node_uptime = {
    condition = "time() - node_boot_time_seconds > 2592000";
    page = false;
    summary = "{{$labels.alias}}: Uptime monster";
    description = "{{$labels.alias}} has been up for more than 30 days.";
  };
}

