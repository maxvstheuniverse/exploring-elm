#!/bin/sh

set -e

js="resources/public/elm.js"

elm make --debug --output=$js $@