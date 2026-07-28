import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/models.dart';
import 'api_service.dart';

/// Mirrors the website's AudioContext (src/context/AudioContext.tsx):
/// plays a real ~30s Spotify preview clip when a track has a spotifyUrl and
/// a preview is available; otherwise falls back to a simulated progress
/// ticker (no audio, matches the website's documented fallback behavior for
/// YouTube-only or preview-less tracks) so the UI still behaves consistently.
class PlayerController extends ChangeNotifier {
  static PlayerController? _instance;
  static PlayerController get instance => _instance ??= PlayerController._();
  PlayerController._();

  final AudioPlayer _player = AudioPlayer();

  Track? currentTrack;
  bool isPlaying = false;
  bool loading = false;
  bool isSpotifyPreview = false;
  int progressSeconds = 0;

  List<Track> _queue = [];
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;
  Timer? _tickerTimer;
  Timer? _playRegisterTimer;

  Future<void> playTrack(Track track, {List<Track>? queue}) async {
    if (queue != null) _queue = queue;

    _tickerTimer?.cancel();
    _playRegisterTimer?.cancel();
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.stop();

    currentTrack = track;
    isPlaying = false;
    progressSeconds = 0;
    isSpotifyPreview = false;
    notifyListeners();

    // Delay registering the play by a few seconds so quickly skipping
    // through tracks doesn't spam the play-count endpoint.
    _playRegisterTimer = Timer(const Duration(seconds: 5), () {
      ApiService.instance.registerPlay(track.id);
    });

    final spotifyUrl = track.spotifyUrl;
    if (spotifyUrl != null && spotifyUrl.isNotEmpty) {
      loading = true;
      notifyListeners();
      final previewUrl = await ApiService.instance.getSpotifyPreview(spotifyUrl);
      loading = false;
      if (previewUrl != null) {
        try {
          await _player.setUrl(previewUrl);
          isSpotifyPreview = true;
          isPlaying = true;
          notifyListeners();
          await _player.play();
          _listenToPlayer();
          return;
        } catch (e) {
          debugPrint('Failed to play Spotify preview: $e');
        }
      }
    }
    // Fallback: no real audio available — simulate playback progress,
    // same behavior as the website's "mock ticker".
    isPlaying = true;
    notifyListeners();
    _startFallbackTicker();
  }

  void _listenToPlayer() {
    _positionSub = _player.positionStream.listen((pos) {
      progressSeconds = pos.inSeconds;
      notifyListeners();
    });
    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying = false;
        progressSeconds = 0;
        notifyListeners();
      }
    });
  }

  void _startFallbackTicker() {
    _tickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isPlaying) return;
      final duration = _parseDurationSeconds(currentTrack?.duration) ?? 180;
      progressSeconds++;
      if (progressSeconds >= duration) {
        progressSeconds = 0;
        isPlaying = false;
      }
      notifyListeners();
    });
  }

  int? _parseDurationSeconds(String? duration) {
    if (duration == null || !duration.contains(':')) return null;
    final parts = duration.split(':');
    if (parts.length != 2) return null;
    final min = int.tryParse(parts[0]) ?? 0;
    final sec = int.tryParse(parts[1]) ?? 0;
    return min * 60 + sec;
  }

  Future<void> togglePlay() async {
    if (currentTrack == null) return;
    if (isSpotifyPreview) {
      if (isPlaying) {
        await _player.pause();
      } else {
        await _player.play();
      }
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void next() {
    if (_queue.isEmpty || currentTrack == null) return;
    final idx = _queue.indexWhere((t) => t.id == currentTrack!.id);
    if (idx == -1) return;
    playTrack(_queue[(idx + 1) % _queue.length], queue: _queue);
  }

  void previous() {
    if (_queue.isEmpty || currentTrack == null) return;
    final idx = _queue.indexWhere((t) => t.id == currentTrack!.id);
    if (idx == -1) return;
    playTrack(_queue[(idx - 1 + _queue.length) % _queue.length], queue: _queue);
  }

  Future<void> seek(int seconds) async {
    if (isSpotifyPreview) {
      await _player.seek(Duration(seconds: seconds));
    }
    progressSeconds = seconds;
    notifyListeners();
  }

  Future<void> close() async {
    _tickerTimer?.cancel();
    _playRegisterTimer?.cancel();
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.stop();
    currentTrack = null;
    isPlaying = false;
    progressSeconds = 0;
    notifyListeners();
  }
}