#!/usr/bin/env python3
import sys

current_key = None
current_count = 0

for line in sys.stdin:
    key, value = line.strip().split('\t')
    try:
        value = int(value)
    except ValueError:
        continue

    if key == current_key:
        current_count += value
    else:
        if current_key:
            print(f"{current_key}\t{current_count}")
        current_key = key
        current_count = value

# Print the last key
if current_key:
    print(f"{current_key}\t{current_count}")
