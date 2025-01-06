#!/bin/bash

# Get the current default sink (audio output device)
current_sink=$(pactl get-default-sink)

# List all available sinks
available_sinks=$(pactl list short sinks | awk '{print $2}')

# Check if current sink is already set to headphones or speakers and toggle accordingly
if [[ "$current_sink" != *Razer_Barracuda_X* ]]; then
  for sink in $available_sinks; do
    if [[ "$sink" == *Razer_Barracuda_X* ]]; then
      pactl set-default-sink "$sink"
      echo "Switched to: $sink (Headphones)"
      exit 0
    fi
  done
else
  for sink in $available_sinks; do
    if [[ "$sink" == *pci-0000* ]]; then
      pactl set-default-sink "$sink"
      echo "Switched to: $sink (Speakers)"
      exit 0
    fi
  done
fi

echo "No switch performed. Could not find matching sinks."
exit 1
