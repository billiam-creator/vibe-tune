import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String _baseUrl = 'https://vibetune-a.vercel.app';

class ApiService {
  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();
  ApiService._();

  String? _deviceId;

  Future<String> getDeviceId() async {
    if (_deviceId != null) return _deviceId!;
    final prefs = await SharedPreferences.getInstance();
    _deviceId = prefs.getString('vibetune_device_id');
    if (_deviceId == null) {
      _deviceId = const Uuid().v4();
      await prefs.setString('vibetune_device_id', _deviceId!);
    }
    return _deviceId!;
  }

  Future<List<Map<String, dynamic>>> getArtists() async {
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/api/artists'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['artists'] != null) {
          return List<Map<String, dynamic>>.from(data['artists']);
        }
      }
    } catch (_) {}
    return [];
  }

  Future<List<Map<String, dynamic>>> getTracks() async {
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/api/tracks'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['tracks'] != null) {
          return List<Map<String, dynamic>>.from(data['tracks']);
        }
      }
    } catch (_) {}
    return [];
  }

  Future<List<Map<String, dynamic>>> getComments() async {
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/api/comments'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['comments'] != null) {
          return List<Map<String, dynamic>>.from(data['comments']);
        }
      }
    } catch (_) {}
    return [];
  }

  Future<List<Map<String, dynamic>>> getGenres() async {
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/api/genres'))
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data is List) return List<Map<String, dynamic>>.from(data);
        if (data is Map && data['genres'] != null) {
          return List<Map<String, dynamic>>.from(data['genres']);
        }
      }
    } catch (_) {}
    return [];
  }

  Future<bool> toggleArtistFlame(String artistId) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.put(
        Uri.parse('$_baseUrl/api/artists/$artistId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'toggleLike', 'deviceId': deviceId}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> registerPlay(String trackId) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.put(
        Uri.parse('$_baseUrl/api/tracks/$trackId/play'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'deviceId': deviceId}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleTrackLike(String trackId) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.put(
        Uri.parse('$_baseUrl/api/tracks/$trackId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'toggleLike', 'deviceId': deviceId}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<bool> postComment({
    required String username,
    required String handle,
    required String text,
    String? trackId,
  }) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.post(
        Uri.parse('$_baseUrl/api/comments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'deviceId': deviceId,
          'username': username,
          'handle': handle,
          'text': text,
          if (trackId != null) 'trackId': trackId,
        }),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> toggleCommentLike(String commentId) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.put(
        Uri.parse('$_baseUrl/api/comments/$commentId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'action': 'toggleLike', 'deviceId': deviceId}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final deviceId = await getDeviceId();
      final res = await http
          .get(Uri.parse('$_baseUrl/api/profiles/$deviceId'))
          .timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } catch (_) {}
    return null;
  }

  Future<bool> saveProfile(String username, String handle) async {
    try {
      final deviceId = await getDeviceId();
      final res = await http.post(
        Uri.parse('$_baseUrl/api/profiles/$deviceId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'handle': handle}),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}