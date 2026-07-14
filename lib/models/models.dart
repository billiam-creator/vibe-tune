import 'package:flutter/material.dart';

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String genre;
  final int flames;
  final String trend;
  final String bio;
  final List<String> tags;

  const Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genre,
    required this.flames,
    required this.trend,
    required this.bio,
    this.tags = const [],
  });
}

class Track {
  final String id;
  final String title;
  final String artist;
  final String artistImageUrl;
  final String coverUrl;
  final String genre;
  final int plays;
  final String duration;
  final bool isNew;
  final bool isTrending;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistImageUrl,
    required this.coverUrl,
    required this.genre,
    required this.plays,
    required this.duration,
    this.isNew = false,
    this.isTrending = false,
  });
}

class VibeCategory {
  final String name;
  final String emoji;
  final Color color;

  const VibeCategory({
    required this.name,
    required this.emoji,
    required this.color,
  });
}