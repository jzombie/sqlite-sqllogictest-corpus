FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    fossil \
    tcl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN fossil clone https://www.sqlite.org/sqllogictest/ /src/sqllogictest.fossil --user root \
 && fossil open --user root /src/sqllogictest.fossil \
 && fossil user default root

WORKDIR /work
RUN cat <<'EOF' >/usr/local/bin/slt-extract
#!/usr/bin/env bash
set -euo pipefail

src_root="/src/test"
dest_root="${1:-/work/test}"

mkdir -p "$dest_root"
cp -R "$src_root/." "$dest_root/"

echo "copied corpus to $dest_root"
EOF

RUN chmod +x /usr/local/bin/slt-extract

ENTRYPOINT ["slt-extract"]
