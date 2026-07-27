import 'package:flutter/material.dart';
import '../models/models.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  static AppState? _instance;
  static AppState get instance => _instance ??= AppState._();
  AppState._();

  List<Artist> artists = [];
  List<Track> tracks = [];
  List<Comment> comments = [];
  List<VibeGenre> genres = [];
  bool loadingArtists = true;
  bool loadingTracks = true;
  bool loadingComments = true;

  String? _deviceId;
  String? userProfile;
  String? userHandle;

  Future<void> init() async {
    try {
      _deviceId = await ApiService.instance.getDeviceId();
      final profile = await ApiService.instance.getProfile();
      if (profile != null) {
        userProfile = profile['username']?.toString();
        userHandle = profile['handle']?.toString();
      }
    } catch (e) {
      debugPrint('AppState.init profile error: $e');
    }
    // Run independently so one failing section doesn't block the others.
    await Future.wait([loadArtists(), loadTracks(), loadComments(), loadGenres()]);
  }

  Future<void> loadArtists() async {
    loadingArtists = true;
    notifyListeners();
    try {
      final data = await ApiService.instance.getArtists();
      artists = data
          .map((j) {
            try {
              return Artist.fromJson(j);
            } catch (e) {
              debugPrint('Skipping malformed artist: $e');
              return null;
            }
          })
          .whereType<Artist>()
          .toList();
    } catch (e) {
      debugPrint('loadArtists error: $e');
    }
    loadingArtists = false;
    _syncTrackArtistNames();
    notifyListeners();
  }

  Future<void> loadTracks() async {
    loadingTracks = true;
    notifyListeners();
    try {
      final data = await ApiService.instance.getTracks();
      tracks = data
          .map((j) {
            try {
              return Track.fromJson(j);
            } catch (e) {
              debugPrint('Skipping malformed track: $e');
              return null;
            }
          })
          .whereType<Track>()
          .toList();
    } catch (e) {
      debugPrint('loadTracks error: $e');
    }
    loadingTracks = false;
    _syncTrackArtistNames();
    notifyListeners();
  }

  // The API doesn't embed an artistName on track/release documents — only
  // artistId. Resolve display names locally from the loaded artists list so
  // tracks don't show blank artist names. Safe to call before artists have
  // loaded; it's re-run whenever either list refreshes.
  void _syncTrackArtistNames() {
    if (artists.isEmpty || tracks.isEmpty) return;
    final byId = {for (final a in artists) a.id: a.name};
    for (final t in tracks) {
      final name = byId[t.artistId];
      if (name != null && name.isNotEmpty) {
        t.artistName = name;
      }
    }
  }

  Future<void> loadComments() async {
    loadingComments = true;
    notifyListeners();
    try {
      final data = await ApiService.instance.getComments();
      comments = data
          .map((j) {
            try {
              return Comment.fromJson(j);
            } catch (e) {
              debugPrint('Skipping malformed comment: $e');
              return null;
            }
          })
          .whereType<Comment>()
          .toList();
    } catch (e) {
      debugPrint('loadComments error: $e');
    }
    loadingComments = false;
    notifyListeners();
  }

  Future<void> loadGenres() async {
    try {
      final data = await ApiService.instance.getGenres();
      genres = data
          .map((j) {
            try {
              return VibeGenre.fromJson(j);
            } catch (e) {
              debugPrint('Skipping malformed genre: $e');
              return null;
            }
          })
          .whereType<VibeGenre>()
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('loadGenres error: $e');
    }
  }

  Future<void> toggleArtistFlame(Artist artist) async {
    // Optimistic update
    final idx = artists.indexOf(artist);
    if (idx == -1) return;
    artist.isLiked = !artist.isLiked;
    notifyListeners();
    await ApiService.instance.toggleArtistFlame(artist.id);
    await loadArtists();
  }

  Future<void> playTrack(Track track) async {
    ApiService.instance.registerPlay(track.id);
  }

  Future<void> toggleTrackLike(Track track) async {
    track.isLiked = !track.isLiked;
    notifyListeners();
    await ApiService.instance.toggleTrackLike(track.id);
    await loadTracks();
  }

  Future<bool> postComment(String text, {String? trackId}) async {
    final name = userProfile ?? 'Anonymous';
    final handle = userHandle ?? '@anon';
    final success = await ApiService.instance.postComment(
      username: name,
      handle: handle,
      text: text,
      trackId: trackId,
    );
    if (success) await loadComments();
    return success;
  }

  Future<void> toggleCommentLike(Comment comment) async {
    comment.isLiked = !comment.isLiked;
    comment.likes += comment.isLiked ? 1 : -1;
    notifyListeners();
    await ApiService.instance.toggleCommentLike(comment.id);
  }

  Future<bool> saveProfile(String username, String handle) async {
    final success = await ApiService.instance.saveProfile(username, handle);
    if (success) {
      userProfile = username;
      userHandle = handle;
      notifyListeners();
    }
    return success;
  }

  List<Artist> get topArtists {
    final sorted = [...artists]..sort((a, b) => b.flameCount.compareTo(a.flameCount));
    return sorted.take(4).toList();
  }

  List<Track> get trendingTracks {
    final sorted = [...tracks]..sort((a, b) => b.playCount.compareTo(a.playCount));
    return sorted.take(6).toList();
  }

  List<Track> get freshDrops {
    return tracks.reversed.take(6).toList();
  }

  List<Artist> get featuredArtists => artists.where((a) => a.featured).toList();
  List<Track> get featuredTracks => tracks.where((t) => t.featured).toList();
}