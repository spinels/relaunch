# Changelog

## 0.15.0 (unreleased)

- Require Ruby 3.3 or newer.
- Publish as `relaunch`, preserving the `rerun` command, `.rerun`
  configuration, and `Rerun` namespace.
- Add `relaunch` as a command alias and `require "relaunch"` as an entry
  point to the existing library.
- Support Ruby 4.0 keyboard input using upstream's `IO#wait_readable` fix.
- Raise `Rerun::ExitException` when the runner exits so library callers can
  handle shutdown. The command continues to exit successfully.

Earlier Rerun releases are documented in the
[upstream version history](README.md#version-history).
