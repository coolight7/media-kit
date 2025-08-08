/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'package:media_kit/src/models/player_log.dart';
import 'package:media_kit/src/models/audio_device.dart';
import 'package:media_kit/src/models/audio_params.dart';
import 'package:media_kit/src/models/video_params.dart';

/// {@template player_stream}
///
/// PlayerStream
/// ------------
///
/// Event [Stream]s for subscribing to [Player] events.
///
/// {@endtemplate}
class PlayerStream {
  /// Whether playing or not.
  final Stream<bool> playing;

  /// Whether end of currently playing [Media] has been reached.
  final Stream<bool> completed;

  /// Current playback position.
  final Stream<Duration> position;

  /// Current playback duration.
  final Stream<Duration> duration;

  /// Current volume.
  final Stream<double> volume;

  /// Current playback rate.
  final Stream<double> rate;

  /// Current pitch.
  final Stream<double> pitch;

  /// Whether buffering or not.
  final Stream<bool> buffering;

  /// Current buffer position.
  /// This indicates how much of the stream has been decoded & cached by the demuxer.
  final Stream<Duration> buffer;

  /// Current buffering percentage
  final Stream<double> bufferingPercentage;

  /// Audio parameters of the currently playing [Media].
  /// e.g. sample rate, channels, etc.
  final Stream<AudioParams> audioParams;

  /// Video parameters of the currently playing [Media].
  /// e.g. width, height, rotation etc.
  final Stream<VideoParams> videoParams;

  /// Audio bitrate of the currently playing [Media].
  final Stream<double?> audioBitrate;

  /// Currently selected [AudioDevice]s.
  final Stream<AudioDevice> audioDevice;

  /// Currently available [AudioDevice]s.
  final Stream<List<AudioDevice>> audioDevices;

  /// Currently playing video's width.
  final Stream<int?> width;

  /// Currently playing video's height.
  final Stream<int?> height;

  /// Currently displayed subtitle.
  final Stream<List<String>> subtitle;

  /// [Stream] emitting internal logs.
  final Stream<PlayerLog> log;

  /// [Stream] emitting error messages. This may be used to handle & display errors to the user.
  final Stream<String> error;

  /// {@macro player_stream}
  const PlayerStream(
    this.playing,
    this.completed,
    this.position,
    this.duration,
    this.volume,
    this.rate,
    this.pitch,
    this.buffering,
    this.bufferingPercentage,
    this.buffer,
    this.audioParams,
    this.videoParams,
    this.audioBitrate,
    this.audioDevice,
    this.audioDevices,
    this.width,
    this.height,
    this.subtitle,
    this.log,
    this.error,
  );
}
