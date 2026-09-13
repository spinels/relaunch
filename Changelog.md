# Changelog

## 0.16.0

- Fix an intermittent crash when restarting a command with `--exit` by
  sharing the child's exit-status waiter between startup and shutdown.
  ([#4](https://github.com/spinels/relaunch/pull/4))

- Enable keyboard controls only when standard input is a terminal and, on
  Unix, the runner is in its foreground process group. This avoids stops
  under supervisors such as Overman and `stty` warnings with redirected
  input while preserving file watching and automatic restarts.
  ([#3](https://github.com/spinels/relaunch/pull/3))

## 0.15.0

- Require Ruby 3.3 or newer.
  ([29a07e1](https://github.com/spinels/relaunch/commit/29a07e19033f828720d5b563e98df09ca5c054dd))
- Publish as `relaunch`, preserving the `rerun` command, `.rerun`
  configuration, and `Rerun` namespace.
  ([b1f9165](https://github.com/spinels/relaunch/commit/b1f91653f800e53f9cd421f844a8dc7d9c366839))
- Add `relaunch` as a command alias and `require "relaunch"` as an entry
  point to the existing library.
  ([b1f9165](https://github.com/spinels/relaunch/commit/b1f91653f800e53f9cd421f844a8dc7d9c366839))
- Support Ruby 4.0 keyboard input using upstream's `IO#wait_readable` fix.
  ([b00ffc6](https://github.com/alexch/rerun/commit/b00ffc6fb7e2c9da676a672200678da0154a60a1))
- Raise `Rerun::ExitException` when the runner exits so library callers can
  handle shutdown. The command continues to exit successfully.
  ([072c356](https://github.com/spinels/relaunch/commit/072c3561fd1581ac2c954c239202e755265de7e2))

Earlier Rerun releases are documented in the
[upstream version history](README.md#version-history).
