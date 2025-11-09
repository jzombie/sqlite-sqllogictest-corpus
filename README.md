# sqlite-sqllogictest-corpus

[![Ask DeepWiki][deepwiki-badge]][deepwiki-page]

Minimal Docker setup that clones the official `sqllogictest` Fossil repository and copies the bundled test corpus into a local folder. Use it whenever you need a fresh snapshot of SQLite's sqllogictest cases.

## Usage

Build the Docker image:

```sh
docker build -t slt-gen .
```

Extract the upstream tests into a local `test/` directory:

```sh
rm -rf test
mkdir test
docker run --rm -v "$PWD/test:/work/test" slt-gen
```

The extracted corpus mirrors the upstream layout directly under `test/`.

## References

- https://sqlite.org/sqllogictest/doc/trunk/about.wiki
- https://github.com/sqlite/sqlite

[deepwiki-page]: https://deepwiki.com/jzombie/sqlite-sqllogictest-corpus
[deepwiki-badge]: https://deepwiki.com/badge.svg
