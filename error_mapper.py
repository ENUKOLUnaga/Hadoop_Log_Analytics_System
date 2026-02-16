#!/usr/bin/env python3
import sys
import re

for line in sys.stdin:
    # Example Apache log format: IP - - [date] "GET /endpoint HTTP/1.1" 404 512
    parts = line.strip().split()
    if len(parts) < 9:
        continue  # skip malformed lines

    status_code = parts[-2]  # usually second last element
    endpoint = parts[6]      # usually request URL

    # Filter error status codes (>= 400)
    try:
        code = int(status_code)
        if code >= 400:
            # Emit both status and endpoint
            print(f"STATUS_{code}\t1")
            print(f"ENDPOINT_{endpoint}\t1")
    except ValueError:
        continue
