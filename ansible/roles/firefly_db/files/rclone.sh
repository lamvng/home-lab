#!/usr/bin/env bash

while [[ $# -gt 0 ]]; do
    case "$1" in
        -source) SOURCE="$2"; shift 2 ;;
        -destination) DESTINATION="$2"; shift 2 ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
done

if [[ -z "${SOURCE:-}" || -z "${DESTINATION:-}" ]]; then
    echo "Usage: $0 -source <source> -destination <destination>"
    exit 1
fi

set -euxo pipefail

rclone cryptcheck "$SOURCE" "$DESTINATION" && exit 0 || CRYPTCHECK_EXIT=$?

# Exit code 0: No difference. 1: Difference. Otherwise unexpected error.
if [[ $CRYPTCHECK_EXIT -ne 1 ]]; then
    echo "cryptcheck failed with unexpected exit code $CRYPTCHECK_EXIT"
    exit $CRYPTCHECK_EXIT
fi

rclone sync "$SOURCE" "$DESTINATION" \
    --create-empty-src-dirs \
    --drive-acknowledge-abuse \
    --drive-skip-gdocs \
    --drive-skip-shortcuts \
    --drive-skip-dangling-shortcuts \
    --fix-case \
    --metadata \
    --modify-window 1s \
    --progress \
    --track-renames
