import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class FlameBadge extends StatelessWidget {
  final int count;
  final bool small;
  const FlameBadge({super.key, required this.count, this.small = false});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('🔥', style: TextStyle(fontSize: small ? 10 : 13)),
        const SizedBox(width: 2),
        Text('$count',
            style: TextStyle(color: VibeTuneTheme.accent, fontWeight: FontWeight.w800, fontSize: small ? 10 : 13)),
      ],
    );
  }
}

class TrendTag extends StatelessWidget {
  final String trend;
  const TrendTag({super.key, required this.trend});

  Color get color {
    switch (trend) {
      case 'NEW': return VibeTuneTheme.neonGreen;
      case 'HOT': return VibeTuneTheme.primary;
      case 'RISING': return VibeTuneTheme.accent;
      default: return VibeTuneTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.6)),
        borderRadius: BorderRadius.circular(2),
        color: color.withOpacity(0.1),
      ),
      child: Text(trend,
          style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
    );
  }
}

class VibeCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const VibeCachedImage({super.key, required this.url, this.width, this.height, this.fit = BoxFit.cover, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return Container(width: width, height: height, color: VibeTuneTheme.card,
          child: const Icon(Icons.music_note, color: VibeTuneTheme.textMuted));
    }
    Widget img = CachedNetworkImage(
      imageUrl: url, width: width, height: height, fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A1A),
        highlightColor: const Color(0xFF2A2A2A),
        child: Container(width: width, height: height, color: const Color(0xFF1A1A1A)),
      ),
      errorWidget: (context, url, error) => Container(width: width, height: height,
          color: VibeTuneTheme.card, child: const Icon(Icons.music_note, color: VibeTuneTheme.textMuted)),
    );
    if (borderRadius != null) return ClipRRect(borderRadius: borderRadius!, child: img);
    return img;
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(title,
              style: const TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(actionText!,
                  style: const TextStyle(color: VibeTuneTheme.primary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ),
        ],
      ),
    );
  }
}

class ArtistGridCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final VoidCallback? onFlame;

  const ArtistGridCard({super.key, required this.artist, this.onTap, this.onFlame});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: VibeTuneTheme.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: VibeTuneTheme.cardBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VibeCachedImage(url: artist.imageUrl, fit: BoxFit.cover),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                  Positioned(top: 8, right: 8, child: TrendTag(trend: artist.trend)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: VibeTuneTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(artist.genre.toUpperCase(),
                          style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600)),
                      GestureDetector(
                        onTap: onFlame,
                        child: FlameBadge(count: artist.flameCount, small: true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackRow extends StatelessWidget {
  final Track track;
  final int? rank;
  final VoidCallback? onPlay;
  final VoidCallback? onLike;

  const TrackRow({super.key, required this.track, this.rank, this.onPlay, this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: VibeTuneTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VibeTuneTheme.cardBorder),
      ),
      child: Row(
        children: [
          if (rank != null) ...[
            SizedBox(width: 28,
                child: Text(rank.toString().padLeft(2, '0'),
                    style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w900))),
            const SizedBox(width: 8),
          ],
          VibeCachedImage(url: track.imageUrl, width: 48, height: 48, borderRadius: BorderRadius.circular(4)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: VibeTuneTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(track.artistName, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 11)),
                Text('${track.formattedPlays} plays',
                    style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onLike,
            child: Icon(track.isLiked ? Icons.favorite : Icons.favorite_border,
                color: track.isLiked ? VibeTuneTheme.primary : VibeTuneTheme.textMuted, size: 18),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onPlay,
            child: const Icon(Icons.play_circle_fill, color: VibeTuneTheme.primary, size: 32),
          ),
        ],
      ),
    );
  }
}

class TopChartArtistRow extends StatelessWidget {
  final Artist artist;
  final int rank;
  final VoidCallback? onFlame;

  const TopChartArtistRow({super.key, required this.artist, required this.rank, this.onFlame});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rank == 1 ? VibeTuneTheme.primary.withOpacity(0.08) : VibeTuneTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: rank == 1 ? VibeTuneTheme.primary.withOpacity(0.3) : VibeTuneTheme.cardBorder),
      ),
      child: Row(
        children: [
          SizedBox(width: 32,
              child: Text(rank.toString().padLeft(2, '0'),
                  style: TextStyle(color: rank == 1 ? VibeTuneTheme.primary : VibeTuneTheme.textMuted,
                      fontSize: 16, fontWeight: FontWeight.w900))),
          const SizedBox(width: 8),
          VibeCachedImage(url: artist.imageUrl, width: 44, height: 44, borderRadius: BorderRadius.circular(22)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(artist.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: VibeTuneTheme.textPrimary, fontWeight: FontWeight.w800, fontSize: 13)),
                Text(artist.genre.toUpperCase(),
                    style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 10, letterSpacing: 1)),
              ],
            ),
          ),
          GestureDetector(onTap: onFlame, child: FlameBadge(count: artist.flameCount)),
          const SizedBox(width: 8),
          TrendTag(trend: artist.trend),
        ],
      ),
    );
  }
}