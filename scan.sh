#!/bin/sh

function scan_page() {

  # Non-interactive? Only support a single page.
  if [ "$(readlink -f /dev/stdin)" == "/dev/null" ]; then
    echo "Scanning single page..." >&2
    scanimage $SCANIMAGE_OPTS --output-file=out0001.pnm >&2

  # Interactive? Prompt for every page as needed.
  else
    scanimage $SCANIMAGE_OPTS --batch --batch-prompt >&2
  fi
}

function finalise_doc() {
  echo -n "Finalising document... " >&2
  convert $CONVERT_OPTS out*.pnm pdf:-
  echo "done." >&2
}

cd "$(mktemp -d)"
scan_page
finalise_doc
