import 'package:just_audio/just_audio.dart';

/// Manager for playing audio (BGM, SE, narration).
///
/// Uses separate players for different audio types to allow
/// simultaneous playback and independent volume control.
class AudioManager {
  AudioManager();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sePlayer = AudioPlayer();
  final AudioPlayer _narrationPlayer = AudioPlayer();

  bool _initialized = false;
  String? _currentBgm;

  // Volume settings (0.0 to 1.0)
  double _bgmVolume = 0.7;
  double _seVolume = 1.0;
  double _narrationVolume = 1.0;
  bool _isMuted = false;

  /// Initialize the audio manager.
  Future<void> init() async {
    if (_initialized) return;

    await _bgmPlayer.setVolume(_bgmVolume);
    await _sePlayer.setVolume(_seVolume);
    await _narrationPlayer.setVolume(_narrationVolume);

    _initialized = true;
  }

  // ============================================
  // Volume Control
  // ============================================

  /// Current BGM volume.
  double get bgmVolume => _bgmVolume;

  /// Set BGM volume (0.0 to 1.0).
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }
  }

  /// Current SE volume.
  double get seVolume => _seVolume;

  /// Set SE volume (0.0 to 1.0).
  Future<void> setSeVolume(double volume) async {
    _seVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _sePlayer.setVolume(_seVolume);
    }
  }

  /// Current narration volume.
  double get narrationVolume => _narrationVolume;

  /// Set narration volume (0.0 to 1.0).
  Future<void> setNarrationVolume(double volume) async {
    _narrationVolume = volume.clamp(0.0, 1.0);
    if (!_isMuted) {
      await _narrationPlayer.setVolume(_narrationVolume);
    }
  }

  /// Whether all audio is muted.
  bool get isMuted => _isMuted;

  /// Mute or unmute all audio.
  Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    if (muted) {
      await _bgmPlayer.setVolume(0);
      await _sePlayer.setVolume(0);
      await _narrationPlayer.setVolume(0);
    } else {
      await _bgmPlayer.setVolume(_bgmVolume);
      await _sePlayer.setVolume(_seVolume);
      await _narrationPlayer.setVolume(_narrationVolume);
    }
  }

  // ============================================
  // BGM Control
  // ============================================

  /// Play background music.
  ///
  /// If the same BGM is already playing, this does nothing.
  Future<void> playBgm(String assetPath, {bool loop = true}) async {
    if (_currentBgm == assetPath && _bgmPlayer.playing) {
      return;
    }

    _currentBgm = assetPath;
    await _bgmPlayer.setAsset(assetPath);
    await _bgmPlayer.setLoopMode(loop ? LoopMode.one : LoopMode.off);
    await _bgmPlayer.play();
  }

  /// Stop background music with optional fade out.
  Future<void> stopBgm({Duration fadeOut = const Duration(milliseconds: 500)}) async {
    if (!_bgmPlayer.playing) return;

    if (fadeOut > Duration.zero) {
      // Fade out
      final steps = 10;
      final stepDuration = fadeOut ~/ steps;
      final volumeStep = _bgmVolume / steps;

      for (var i = 0; i < steps; i++) {
        await Future.delayed(stepDuration);
        await _bgmPlayer.setVolume((_bgmVolume - (volumeStep * (i + 1))).clamp(0.0, 1.0));
      }
    }

    await _bgmPlayer.stop();
    await _bgmPlayer.setVolume(_isMuted ? 0 : _bgmVolume);
    _currentBgm = null;
  }

  /// Pause background music.
  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
  }

  /// Resume background music.
  Future<void> resumeBgm() async {
    await _bgmPlayer.play();
  }

  /// Whether BGM is currently playing.
  bool get isBgmPlaying => _bgmPlayer.playing;

  /// Current BGM asset path.
  String? get currentBgm => _currentBgm;

  // ============================================
  // Sound Effects Control
  // ============================================

  /// Play a sound effect.
  ///
  /// Sound effects are short and don't loop.
  Future<void> playSe(String assetPath) async {
    await _sePlayer.setAsset(assetPath);
    await _sePlayer.seek(Duration.zero);
    await _sePlayer.play();
  }

  // ============================================
  // Narration Control (for Picture Book)
  // ============================================

  /// Play narration audio.
  Future<void> playNarration(String assetPath) async {
    await _narrationPlayer.setAsset(assetPath);
    await _narrationPlayer.play();
  }

  /// Pause narration.
  Future<void> pauseNarration() async {
    await _narrationPlayer.pause();
  }

  /// Resume narration.
  Future<void> resumeNarration() async {
    await _narrationPlayer.play();
  }

  /// Stop narration.
  Future<void> stopNarration() async {
    await _narrationPlayer.stop();
  }

  /// Seek narration to a specific position.
  Future<void> seekNarration(Duration position) async {
    await _narrationPlayer.seek(position);
  }

  /// Stream of current narration position.
  Stream<Duration> get narrationPositionStream => _narrationPlayer.positionStream;

  /// Stream of narration duration.
  Stream<Duration?> get narrationDurationStream => _narrationPlayer.durationStream;

  /// Stream of narration player state.
  Stream<PlayerState> get narrationStateStream => _narrationPlayer.playerStateStream;

  /// Current narration position.
  Duration get narrationPosition => _narrationPlayer.position;

  /// Total narration duration.
  Duration? get narrationDuration => _narrationPlayer.duration;

  /// Whether narration is currently playing.
  bool get isNarrationPlaying => _narrationPlayer.playing;

  // ============================================
  // Night Mode
  // ============================================

  /// Enable night mode (reduces volumes).
  Future<void> enableNightMode() async {
    await _bgmPlayer.setVolume((_bgmVolume * 0.5).clamp(0.0, 1.0));
    await _sePlayer.setVolume((_seVolume * 0.3).clamp(0.0, 1.0));
    // Keep narration at full volume
  }

  /// Disable night mode (restores volumes).
  Future<void> disableNightMode() async {
    if (!_isMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
      await _sePlayer.setVolume(_seVolume);
    }
  }

  // ============================================
  // Cleanup
  // ============================================

  /// Dispose all audio players.
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sePlayer.dispose();
    await _narrationPlayer.dispose();
    _initialized = false;
  }
}
