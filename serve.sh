#!/bin/sh

# -- elm reactor doesn't seem to support embedded applications.
python3 -m http.server 1625 --bind 127.0.0.1 --directory=resources/public