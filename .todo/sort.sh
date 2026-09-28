#!/bin/sh

set -e

awk '
function isdate(s) { return s ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ }
{
  d = "9999-99-99"; p = "~"          # defaults: no date / no priority sort last
  if ($2 ~ /^\([A-Z]\)$/) { p = $2; if (isdate($3)) d = $3 }
  else if (isdate($2)) d = $2
  printf "%s\t%s\t%s\t%s\n", d, p, $1, $0
}' | LC_ALL=C sort -t "$(printf '\t')" -k1,1 -k2,2 -k3,3n | cut -f4-
