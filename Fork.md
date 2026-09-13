# Fork history

Relaunch is a fork of [alexch/rerun](https://github.com/alexch/rerun).
Functional changes are listed newest first.

## September 13, 2026: Preserve exit status during restart

Fix [#1](https://github.com/spinels/relaunch/issues/1), an intermittent
`undefined method 'success?' for nil` crash when restarting with `--exit`.
Shutdown now waits for the existing detached process waiter instead of
collecting the child's status with a competing `Process.wait` call.

## September 13, 2026: Minimum Ruby version

Relaunch requires Ruby 3.3 or newer.

## September 13, 2026: Relaunch gem and command alias

The fork uses the gem name `relaunch`, with 0.15.0 as its first planned
release. Like [Overman](https://github.com/spinels/overman), it has its own
package identity while retaining compatibility with upstream usage.

The `rerun` executable, `.rerun` configuration, `require "rerun"`, and the
`Rerun` namespace are preserved. The additional `relaunch` executable loads
the existing command, and `require "relaunch"` loads the same library.
Applications can replace the `rerun` gem with `relaunch` without changing
their commands or configuration.

## September 13, 2026: Ruby 4.0 keyboard input compatibility

[f2b5cf5](https://github.com/spinels/rerun/commit/f2b5cf5e641e6709d40a8fa03b961e9560ff0e6f)
merged upstream while retaining the fork's exit handling. The import
includes upstream's
[b00ffc6](https://github.com/alexch/rerun/commit/b00ffc6fb7e2c9da676a672200678da0154a60a1),
which uses `IO#wait_readable` when available and falls back to `IO#ready?`
for older Rubies, fixing keyboard input compatibility with Ruby 4.0.

## January 26, 2026: Let callers handle runner exits

[072c356](https://github.com/spinels/rerun/commit/072c3561fd1581ac2c954c239202e755265de7e2)
introduced `Rerun::ExitException`. The runner raises it instead of calling
`exit` when stopping or handling a launch error, allowing tests and library
callers to catch it. The `rerun` executable catches the exception and exits
successfully, preserving its command-line behavior.

This remains a runtime difference from upstream and should be preserved
when importing upstream changes.
