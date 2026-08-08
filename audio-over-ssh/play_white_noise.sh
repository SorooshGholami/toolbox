#!/bin/bash
# Plays white noise through the default audio output using /dev/urandom
# as a raw PCM source. Press Ctrl+C to stop.
# Requires: aplay (alsa-utils)

aplay -c 2 -f S16_LE -r 44100 /dev/urandom
