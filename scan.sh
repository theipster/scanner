#!/bin/sh

function scan_page() {
  echo "Scanning page $2..." >&2
  scanimage $SCANIMAGE_OPTS | convert $CONVERT_OPTS - "$1/page-$2.pdf" >&2
}

function finalise_doc() {
  echo -n "Finalising... " >&2
  convert "$1/page-*.pdf" pdf:-
  echo "done." >&2
}

tempdir=$(mktemp -d)
page=1
while [ $page -gt 0 ]; do

  # Do scan
  scan_page "$tempdir" "$page"

  # Non-interactive? Only support single page.
  if [ "$(readlink -f /dev/stdin)" == "/dev/null" ]; then
    finalise_doc "$tempdir"
    exit
  fi

  # Repeat?
  continue=""
  while [ ! $(expr "$continue" : '[Yy]' >/dev/null) ]; do
    echo "Scan another page? ([Y]es for another, [N]o to finish here, or [Q] to quit.)  " >&2
    read continue
    case "$continue" in
      [Yy])
        page=$((page+1))
        break
        ;;
      [Nn])
        finalise_doc "$tempdir"
        exit
        ;;
      [Qq])
        exit
        ;;
      *)
        echo "Invalid command, please retry. " >&2
        ;;
    esac
  done
done
