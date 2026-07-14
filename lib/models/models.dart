import 'package:flutter/material.dart';

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String genre;
  final int flameCount;
  final bool featured;
  final String? bio;
  final String? youtubeUrl;
  final String? spotifyUrl;
  bool isLiked;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.flameCount,
    this.featured = false,
    this.bio,
    this.youtubeUrl,
    this.spotifyUrl,
    this.isLiked = false,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Artist',
      imageUrl: json['imageUrl']?.toString() ?? '',
      genre: json['genre']?.toString() ?? '',
      flameCount: (json['flameCount'] ?? json['likes'] ?? 0) as int,
      featured: json['featured'] == true,
      bio: json['bio']?.toString(),
      youtubeUrl: json['youtubeUrl']?.toString(),
      spotifyUrl: json['spotifyUrl']?.toString(),
    );
  }

  String get trend {
    if (flameCount >= 8) return 'HOT';
    if (flameCount >= 5) return 'RISING';
    if (flameCount <= 1) return 'NEW';
    return 'STABLE';
  }
}

class Track {
  final String id;
  final String title;
  final String artistId;
  final String artistName;
  final String imageUrl;
  final String genre;
  final int playCount;
  final int likesCount;
  final String? youtubeUrl;
  final String? spotifyUrl;
  final String? duration;
  final bool featured;
  bool isLiked;

  Track({
    required this.id,
    required this.title,
    required this.artistId,
    required this.artistName,
    required this.imageUrl,
    required this.genre,
    required this.playCount,
    required this.likesCount,
    this.youtubeUrl,
    this.spotifyUrl,
    this.duration,
    this.featured = false,
    this.isLiked = false,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Unknown Track',
      artistId: json['artistId']?.toString() ?? '',
      artistName: json['artistName']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      genre: json['genre']?.toString() ?? '',
      playCount: (json['playCount'] ?? json['plays'] ?? 0) as int,
      likesCount: (json['likesCount'] ?? json['likes'] ?? 0) as int,
      youtubeUrl: json['youtubeUrl']?.toString(),
      spotifyUrl: json['spotifyUrl']?.toString(),
      duration: json['duration']?.toString(),
      featured: json['featured'] == true,
    );
  }

  String get formattedPlays {
    if (playCount >= 1000000) return '${(playCount / 1000000).toStringAsFixed(1)}M';
    if (playCount >= 1000) return '${(playCount / 1000).toStringAsFixed(1)}K';
    return playCount.toString();
  }
}

class Comment {
  final String id;
  final String deviceId;
  final String username;
  final String handle;
  final String text;
  int likes;
  final int createdAt;
  final String? trackId;
  bool isLiked;

  Comment({
    required this.id,
    required this.deviceId,
    required this.username,
    required this.handle,
    required this.text,
    required this.likes,
    required this.createdAt,
    this.trackId,
    this.isLiked = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      deviceId: json['deviceId']?.toString() ?? '',
      username: json['username']?.toString() ?? 'Anonymous',
      handle: json['handle']?.toString() ?? '@anon',
      text: json['text']?.toString() ?? '',
      likes: (json['likes'] ?? 0) as int,
      createdAt: (json['createdAt'] ?? 0) as int,
      trackId: json['trackId']?.toString(),
    );
  }

  DateTime get createdDate =>
      DateTime.fromMillisecondsSinceEpoch(createdAt);
}

class VibeGenre {
  final String id;
  final String name;

  const VibeGenre({required this.id, required this.name});

  factory VibeGenre.fromJson(Map<String, dynamic> json) {
    return VibeGenre(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Color get color {
    switch (name.toLowerCase()) {
      case 'gengetone': return const Color(0xFFFF3D00);
      case 'drill':
      case 'nairobi drill': return const Color(0xFF6C00FF);
      case 'afro trap':
      case 'afro-pop': return const Color(0xFFFFD600);
      case 'house': return const Color(0xFF00E5FF);
      case 'r&b': return const Color(0xFFFF6B9D);
      default: return const Color(0xFF39FF14);
    }
  }

  String get emoji {
    switch (name.toLowerCase()) {
      case 'gengetone': return '🔥';
      case 'drill':
      case 'nairobi drill': return '💀';
      case 'afro trap':
      case 'afro-pop': return '⚡';
      case 'house': return '🎧';
      case 'r&b': return '💿';
      default: return '🎤';
    }
  }
}