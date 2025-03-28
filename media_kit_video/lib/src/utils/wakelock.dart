/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Julien Muret <birros@protonmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

/// {@template wakelock}
/// Wakelock
/// --------
///
/// This class acquires & releases the wakelock based on reference count.
///
/// {@endtemplate}
class Wakelock {
  /// {@macro wakelock}
  Wakelock();

  /// Marks the wakelock as enabled for this instance.
  void enable() {
    if (!_enabled) {
      _enabled = true;
      _update();
    }
  }

  /// Marks the wakelock as disabled for this instance.
  void disable() {
    if (_enabled) {
      _enabled = false;
      _update();
    }
  }

  /// Acquires the wakelock if enabled count is greater than 0.
  void _update() {

  }

  /// Whether the wakelock is enabled for this instance.
  bool _enabled = false;
}
