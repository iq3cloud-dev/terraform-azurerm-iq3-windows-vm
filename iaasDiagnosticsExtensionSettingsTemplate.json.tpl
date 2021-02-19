{
  "StorageAccount": "${log_storage_account_name}",
  "WadCfg": {
    "DiagnosticMonitorConfiguration": {
      "overallQuotaInMB": 5120,
      "Metrics": {
        "resourceId": "${virtual_machine_id}",
        "MetricAggregation": [
          {
            "scheduledTransferPeriod": "PT1H"
          },
          {
            "scheduledTransferPeriod": "PT1M"
          }
        ]
      },
      "DiagnosticInfrastructureLogs": {
        "scheduledTransferLogLevelFilter": "Warning"
      },
      "Logs": {
        "scheduledTransferPeriod": "PT1M",
        "scheduledTransferLogLevelFilter": "Warning"
      },
      "PerformanceCounters": {
        "scheduledTransferPeriod": "PT1M",
        "PerformanceCounterConfiguration": [
          {
            "counterSpecifier": "\\Processor Information(_Total)\\% Processor Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Processor Information(_Total)\\% Privileged Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Processor Information(_Total)\\% User Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Processor Information(_Total)\\Processor Frequency",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\System\\Processes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Process(_Total)\\Thread Count",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Process(_Total)\\Handle Count",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\System\\System Up Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\System\\Context Switches/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\System\\Processor Queue Length",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\% Committed Bytes In Use",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Available Bytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Committed Bytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Cache Bytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Pool Paged Bytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Pool Nonpaged Bytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Pages/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Memory\\Page Faults/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Process(_Total)\\Working Set",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Process(_Total)\\Working Set - Private",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Read Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\% Disk Write Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\% Idle Time",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Bytes/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Read Bytes/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Write Bytes/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Transfers/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Reads/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Disk Writes/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Transfer",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Read",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk sec/Write",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Queue Length",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Read Queue Length",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Avg. Disk Write Queue Length",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\% Free Space",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\LogicalDisk(_Total)\\Free Megabytes",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Bytes Total/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Bytes Sent/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Bytes Received/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Packets/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Packets Sent/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Packets Received/sec",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Packets Outbound Errors",
            "sampleRate": "PT1M"
          },
          {
            "counterSpecifier": "\\Network Interface(*)\\Packets Received Errors",
            "sampleRate": "PT1M"
          }
        ]
      },
      "WindowsEventLog": {
        "scheduledTransferPeriod": "PT1M",
        "DataSource": [
          {
            "name": "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
          },
          {
            "name": "Security!*[System[band(Keywords,4503599627370496)]]"
          },
          {
            "name": "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
          }
        ]
      }
    }
  }
}