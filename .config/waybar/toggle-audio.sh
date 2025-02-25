#!/bin/bash

# Get the current default sink (audio output device)
current_sink=$(pactl get-default-sink)

# List all available sinks
available_sinks=$(pactl list short sinks | awk '{print $2}')
available_sources=$(pactl list short sources | awk '{print $2}')

# Check if current sink is already set to headphones or speakers and toggle accordingly
if [[ "$current_sink" != *Razer_Barracuda_X* ]]; then
  for sink in $available_sinks; do
    if [[ "$sink" == *Razer_Barracuda_X* ]]; then
      pactl set-default-sink "$sink"
      echo "Switched sink to: $sink (Headphones)"
    fi
  done
  for source in $available_sources; do
    if [[ "$source" == *input*Razer_Barracuda_X* ]]; then
      pactl set-default-source "$source"
      echo "Switched source to: $source (Headphones)"
    fi
  done
else
  for sink in $available_sinks; do
    if [[ "$sink" == *pci-0000* ]]; then
      pactl set-default-sink "$sink"
      echo "Switched sink to: $sink (Speakers)"
    fi
  done
  for source in $available_sources; do
    if [[ "$source" == *input*pci-0000* ]]; then
      pactl set-default-source "$source"
      echo "Switched source to: $source (Built-in)"
    fi
  done
fi
