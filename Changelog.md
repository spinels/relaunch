# Changelog

## Unreleased

- Fix an intermittent crash when restarting a command with `--exit` by
  sharing the child's exit-status waiter between startup and shutdown.

## 0.15.0 (unreleased)

- Enable keyboard controls only when standard input is a terminal and, on
  Unix, the runner is in its foreground process group. This avoids stops
  under supervisors such as Overman and `stty` warnings with redirected
  input while preserving file watching and automatic restarts.
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
