compress() {
  if [[ "$1" == "--help" || "$1" == "-h" || $# -lt 2 ]]; then
    cat <<EOF
Usage: compress <format> <target> [--password <password>]

Compress a file or directory into:
  zip     →  zip [-P password]
  tar.gz  →  tar czf
  tar.bz2 →  tar cjf
  tar.xz  →  tar cJf
  7z      →  7z a [-p password]

Examples:
  compress zip my_folder
  compress zip my_folder --password mypass
  compress tar.gz my_file.txt
  compress 7z my_dir --password secret
EOF
    return 0
  fi

  local format="$1"
  shift
  local target="$1"
  shift

  local password=""
  if [[ "$1" == "--password" && -n "$2" ]]; then
    password="$2"
    shift 2
  fi

  case "$format" in
    zip)
      if [[ -n "$password" ]]; then
        zip -r -P "$password" "$target.zip" "$target"
      else
        zip -r "$target.zip" "$target"
      fi
      ;;
    tar.gz)
      tar czf "$target.tar.gz" "$target"
      ;;
    tar.bz2)
      tar cjf "$target.tar.bz2" "$target"
      ;;
    tar.xz)
      tar cJf "$target.tar.xz" "$target"
      ;;
    7z)
      if [[ -n "$password" ]]; then
        7z a -p"$password" "$target.7z" "$target"
      else
        7z a "$target.7z" "$target"
      fi
      ;;
    *)
      echo "compress: unsupported format '$format'"
      echo "Try: compress --help"
      return 1
      ;;
  esac
}

extract() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat <<EOF
Usage: extract <archive-file>

Extracts supported archive formats. If password is required, you'll be prompted.

Supported formats:
  .tar        →  tar xvf
  .tar.gz     →  tar xvzf
  .tar.bz2    →  tar xvjf
  .tar.xz     →  tar xvJf
  .gz         →  gunzip
  .bz2        →  bunzip2
  .xz         →  unxz
  .zip        →  unzip (prompts for password if needed)
  .rar        →  unar (prompts for password if needed)
  .7z         →  7z x (prompts for password if needed)

Example:
  extract archive.tar.gz
EOF
    return 0
  fi

  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a valid file"
    echo "Try: extract --help"
    return 1
  fi

  local file="$1"
  case "$file" in
    *.tar)       tar xvf "$file" ;;
    *.tar.gz)    tar xvzf "$file" ;;
    *.tar.bz2)   tar xvjf "$file" ;;
    *.tar.xz)    tar xvJf "$file" ;;
    *.gz)        gunzip "$file" ;;
    *.bz2)       bunzip2 "$file" ;;
    *.xz)        unxz "$file" ;;
    *.zip)       unzip "$file" ;;
    *.rar)       unar "$file" ;;
    *.7z)        7z x "$file" ;;
    *)
      echo "extract: unknown format: $file"
      return 1
      ;;
  esac
}
