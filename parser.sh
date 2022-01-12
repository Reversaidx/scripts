#!/usr/bin/env bash
set -e
TMPDIR=$(mktemp -d)
ARCHIVE=""
if [ ! -e $TMPDIR ]; then
    >&2 echo "Failed to create temp directory"
    exit 1
fi
trap "exit 1"           HUP INT PIPE QUIT TERM
trap 'rm -rf "$TMPDIR"' EXIT
tar -xf $ARCHIVE -C $TMPDIR
filesList=$(ls $TMPDIR | awk -F. '{print $2}' )
echo $filesList
for i in $filesList;do
    cat $TMPDIR/access.$i.log|awk  '$3!="127.0.0.1" && $2>=500 {print $0}'>>./test
done

exit 0
