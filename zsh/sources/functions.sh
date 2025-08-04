compress() {
  if [[ "$1" == "--help" || "$1" == "-h" || $# -lt 2 ]]; then
    cat <<EOF
Usage: compress <format> <file_or_dir> [--password]

Formats:
  zip     →  zip [-P password]
  tar.gz  →  tar czf
  tar.bz2 →  tar cjf
  tar.xz  →  tar cJf
  7z      →  7z a [-p password]

Examples:
  compress zip my_folder
  compress zip my_folder --password      # interactive prompt
  compress tar.gz notes.txt
EOF
    return 0
  fi

  local format="$1"
  shift
  local target="$1"
  shift

  if [[ ! -e "$target" ]]; then
    echo "compress: target '$target' does not exist"
    return 1
  fi

  local password=""
  if [[ "$1" == "--password" ]]; then
    echo -n "Enter password: "
    read -s password
    echo
    echo -n "Confirm password: "
    read -s confirm
    echo
    if [[ "$password" != "$confirm" ]]; then
      echo "Passwords do not match."
      return 1
    fi
    shift
  fi

  local base_name
  base_name=$(basename "$target")
  local dir_name
  dir_name=$(cd "$(dirname "$target")" && pwd)

  case "$format" in
    zip)
      (cd "$dir_name" && \
        [[ -n "$password" ]] && zip -r -P "$password" "$base_name.zip" "$base_name" || \
        zip -r "$base_name.zip" "$base_name")
      ;;
    tar.gz)
      tar czf "$dir_name/$base_name.tar.gz" -C "$dir_name" "$base_name"
      ;;
    tar.bz2)
      tar cjf "$dir_name/$base_name.tar.bz2" -C "$dir_name" "$base_name"
      ;;
    tar.xz)
      tar cJf "$dir_name/$base_name.tar.xz" -C "$dir_name" "$base_name"
      ;;
    7z)
      if [[ -n "$password" ]]; then
        7z a -p"$password" "$dir_name/$base_name.7z" "$target"
      else
        7z a "$dir_name/$base_name.7z" "$target"
      fi
      ;;
    *)
      echo "compress: unsupported format '$format'"
      return 1
      ;;
  esac
}

extract() {
  if [[ "$1" == "--help" || "$1" == "-h" || $# -lt 1 ]]; then
    cat <<EOF
Usage: extract <archive> [--password]

Supported formats:
  .zip     →  unzip [-P password]
  .tar.gz  →  tar xzf
  .tar.bz2 →  tar xjf
  .tar.xz  →  tar xJf
  .7z      →  7z x [-p password]

Examples:
  extract archive.zip
  extract archive.7z --password     # prompt for password
EOF
    return 0
  fi

  local archive="$1"
  shift

  if [[ ! -f "$archive" ]]; then
    echo "extract: file '$archive' not found"
    return 1
  fi

  local password=""
  if [[ "$1" == "--password" ]]; then
    echo -n "Enter password: "
    read -s password
    echo
    shift
  fi

  case "$archive" in
    *.zip)
      if [[ -n "$password" ]]; then
        unzip -P "$password" "$archive"
      else
        unzip "$archive"
      fi
      ;;
    *.tar.gz)
      tar xzf "$archive"
      ;;
    *.tar.bz2)
      tar xjf "$archive"
      ;;
    *.tar.xz)
      tar xJf "$archive"
      ;;
    *.7z)
      if [[ -n "$password" ]]; then
        7z x -p"$password" "$archive"
      else
        7z x "$archive"
      fi
      ;;
    *)
      echo "extract: unsupported file format '$archive'"
      return 1
      ;;
  esac
}
