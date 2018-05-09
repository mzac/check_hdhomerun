# Introduction

This plugin will allow you to check if your HD Homerun is currently tuned to any channels.  This could 
be useful if you want to upgrade for example a Plex server that is currently recording.  One glance
in Icinga2 could tell you if recording is in progress.

# Example

![Icinga not tuned](/icinga-not-tuned.png)
![Icinga tuned](/icinga-tuned.png)

# Requirements

* hdhomerun-config

# Installation

Install and test hdhomerun-config
```
# apt install hdhomerun-config
# hdhomerun_config discover
hdhomerun device abcd1234 found at 192.168.0.37
```

```
Install check_hdhomerun plugin
# cd /tmp
# git clone https://github.com/mzac/check_hdhomerun.git
```

Copy the check_hdhomerun.sh into your CustomScriptDir or wherever you have your scripts

# Configuration for Icinga2

```
object CheckCommand "check-hdhomerun" {
	import "plugin-check-command"

	command = [ CustomScriptDir + "/check_hdhomerun.sh" ]

	arguments = {
		"-i" = "$address$"
	}
}

object HostGroup "hdhomerun" {
  display_name = "hdhomerun"
}

apply Service "HDHomerun Tuner" {
	import "generic-service"
	check_command = "check-hdhomerun"
	
	enable_notifications = false
	
	assign where "hdhomerun" in host.groups
}
```

```
object Host "hr1" {
  import "generic-host"

  address = "192.168.0.37"

  groups = [ "hdhomerun" ]
}
```
