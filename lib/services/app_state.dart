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
    _deviceId = await ApiService.instance.getDeviceId();
    final profile = await ApiService.instance.getProfile();
    if (profile != null) {
      userProfile = profile['username']?.toString();
      userHandle = profile['handle']?.toString();
    }
    await Future.wait([loadArtists(), loadTracks(), loadComments(), loadGenres()]);
  }

  Future<void> loadArtists() async {
    loadingArtists = true;
    notifyListeners();
    final data = await ApiService.instance.getArtists();
    artists = data.map((j) => Artist.fromJson(j)).toList();
    loadingArtists = false;
    notifyListeners();
  }

  Future<void> loadTracks() async {
    loadingTracks = true;
    notifyListeners();
    final data = await ApiService.instance.getTracks();
    tracks = data.map((j) => Track.fromJson(j)).toList();
    loadingTracks = false;
    notifyListeners();
  }

  Future<void> loadComments() async {
    loadingComments = true;
    notifyListeners();
    final data = await ApiService.instance.getComments();
    comments = data.map((j) => Comment.fromJson(j)).toList();
    loadingComments = false;
    notifyListeners();
  }

  Future<void> loadGenres() async {
    final data = await ApiService.instance.getGenres();
    genres = data.map((j) => VibeGenre.fromJson(j)).toList();
    notifyListeners();
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