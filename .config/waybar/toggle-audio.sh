#!/bin/bash

set -e

# Get the current default sink
current_sink=$(pactl get-default-sink)

# List all available sinks and sources
available_sinks=$(pactl list short sinks | awk '{print $2}')
available_sources=$(pactl list short sources | awk '{print $2}')

# Define device patterns in order of preference for cycling
declare -A device_patterns=(
	["Razer"]="*Razer_Barracuda_X*"
	["Bluetooth"]="*bluez*"
	["Speakers"]="*pci-0000*"
)

# Find which devices are currently available
available_devices=()
for device in "Razer" "Bluetooth" "Speakers"; do
	pattern="${device_patterns[$device]}"
	for sink in $available_sinks; do
		if [[ "$sink" == $pattern ]]; then
			echo "DEBUG: $pattern is available"
			available_devices+=("$device")
			break
		fi
	done
done

# If no devices found, exit
if [ ${#available_devices[@]} -eq 0 ]; then
	echo "No recognized audio devices found"
	exit 1
fi

# Find current device index
current_index=-1
for i in "${!available_devices[@]}"; do
	device="${available_devices[$i]}"
	pattern="${device_patterns[$device]}"
	if [[ "$current_sink" == $pattern ]]; then
		echo "DEBUG: $pattern is the current sink"
		current_index=$i
		break
	fi
done

# Calculate next device index (cycle through available devices)
next_index=$(((current_index + 1) % ${#available_devices[@]}))
next_device="${available_devices[$next_index]}"
next_pattern="${device_patterns[$next_device]}"

# Switch to next device
for sink in $available_sinks; do
	if [[ "$sink" == $next_pattern ]]; then
		pactl set-default-sink "$sink"
		echo "Switched sink to: $sink ($next_device)"
		break
	fi
done

# Switch source to match - handle both regular and bluetooth naming
for source in $available_sources; do
	# For bluetooth, match bluez_input; for others, match input and pattern
	if [[ "$next_device" == "Bluetooth" && "$source" == *bluez_input* ]] ||
		[[ "$next_device" != "Bluetooth" && "$source" == *input* && "$source" == $next_pattern ]]; then
		pactl set-default-source "$source"
		echo "Switched source to: $source ($next_device)"
		break
	fi
done
