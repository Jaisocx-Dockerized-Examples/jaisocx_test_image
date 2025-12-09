#!/bin/sh

get_alpine_url() {
  local platform="$1"

  case "${platform}" in
    "linux/amd64")   echo "x86_64" ;;
    "linux/arm/v6")  echo "armhf" ;;
    "linux/arm/v7")  echo "armv7" ;;
    "linux/arm64")   echo "aarch64" ;;
    "linux/386")     echo "x86" ;;
    "linux/ppc64le") echo "ppc64le" ;;
    "linux/riscv64") echo "riscv64" ;;
    "linux/s390x")   echo "s390x" ;;
    *)               echo "unsupported" ;;
  esac
}


# export ALPINE_COMMUNITY_URL="$(get_alpine_url "$1")"
url="$(get_alpine_url "$1")"
# echo "ALPINE_COMMUNITY_URL=${url}\n\n\n"

printf 'ALPINE_COMMUNITY_URL="%s"\n\n' "$url"

# echo "${ALPINE_COMMUNITY_URL}"

