# syntax=docker/dockerfile:1.4
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive \
  USER=slt \
  HOME=/home/slt

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    fossil \
    tcl \
 && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash "$USER" \
 && mkdir -p /src /work \
 && chown -R "$USER":"$USER" /src /work

USER slt

WORKDIR /src
RUN fossil clone https://www.sqlite.org/sqllogictest/ /src/sqllogictest.fossil --user "$USER" \
 && fossil open --user "$USER" /src/sqllogictest.fossil \
 && fossil user default "$USER"

USER root

WORKDIR /work
RUN cat <<'EOF' >/usr/local/bin/slt-extract
#!/usr/bin/env bash
set -euo pipefail

src_root="/src/test"
dest_root="${1:-/work/test}"

mkdir -p "$dest_root"
cp -a "$src_root/." "$dest_root/"

echo "copied corpus to $dest_root"
EOF

RUN chmod +x /usr/local/bin/slt-extract

USER slt
ENTRYPOINT ["slt-extract"]
