#!/bin/bash
# Encrypts a local file with AES-256 and copies it to a remote host over scp,
# then plays a sound to signal success/failure.
#
# Usage: ./secure_copy.sh <local_file> <user@remote_host> [remote_path]
#
# You'll be prompted for the encryption passphrase (openssl reads it from stdin,
# it is never stored or hardcoded).

src="$1"
remote="$2"
remote_path="${3:-/root/}"

if [[ -z "$src" || -z "$remote" ]]; then
    echo "Usage: $0 <local_file> <user@remote_host> [remote_path]"
    exit 1
fi

out="${src}.enc"

openssl enc -aes-256-cbc -salt -pbkdf2 -in "$src" -out "$out"
scp "$out" "${remote}:${remote_path}"
status=$?

if command -v paplay >/dev/null 2>&1; then
    if [[ "$status" -eq 0 ]]; then
        paplay /usr/share/sounds/freedesktop/stereo/complete.oga
    else
        paplay /usr/share/sounds/freedesktop/stereo/suspend-error.oga
    fi
fi

exit "$status"
