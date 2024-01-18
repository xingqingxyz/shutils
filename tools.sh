for f in /usr/local/lib/bash/z.sh /dev/null; do
  if [ -f "$f" ]; then
    # shellcheck source=/usr/local/lib/bash/z.sh
    . "$f"
  fi
done
