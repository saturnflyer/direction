# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [2.0.2] - Unreleased

### Performance

- `command`/`def_command` now generate the forwarding method as source using
  `(...)` argument forwarding. Forwarded calls allocate zero objects (previously
  3 for positional/keyword and 5 for block calls) and run roughly 2.8x-5x faster
  on Ruby 4.0, since receiver lookup and the forwarded send are plain
  inline-cacheable calls (friendly to Object Shapes and YJIT) instead of dynamic
  `__send__`. Setter and operator method names fall back to `define_method` and
  remain supported.

### Changed

- Require Ruby >= 3.2 (was >= 2.7), dropping EOL versions.
- CI tests Ruby 3.3, 3.4, and 4.0.

## [2.0.1] - 2026-06-24

### Fixed

- command supports bang, predicate, setter, and operator method names (956cd57)
- require forwardable so extending Direction works without a prior require (956cd57)
