import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ─── Flame Badge ───────────────────────────────────────────────────────────────
class FlameBadge extends StatelessWidget {
  final int count;
  final bool small;
  const FlameBadge({super.key, required this.count, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '🔥',
          style: TextStyle(fontSize: small ? 10 : 13),
        ),
        const SizedBox(width: 2),
        Text(
          '$count',
          style: TextStyle(
            color: VibeTuneTheme.accent,
            fontWeight: FontWeight.w800,
            fontSize: small ? 10 : 13,
          ),
        ),
      ],
    );
  }
}

// ─── Trend Tag ─────────────────────────────────────────────────────────────────
class TrendTag extends StatelessWidget {
  final String trend;
  const TrendTag({super.key, required this.trend});

  Color get color {
    switch (trend) {
      case 'NEW':
        return VibeTuneTheme.neonGreen;
      case 'HOT':
        return VibeTuneTheme.primary;
      case 'RISING':
        return VibeTuneTheme.accent;
      default:
        return VibeTuneTheme.textMuted;
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
      child: Text(
        trend,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ─── Network Image with Shimmer ─────────────────────────────────────────────────
class VibeCachedImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const VibeCachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget img = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: const Color(0xFF1A1A1A),
        highlightColor: const Color(0xFF2A2A2A),
        child: Container(
          width: width,
          height: height,
          color: const Color(0xFF1A1A1A),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: const Color(0xFF1A1A1A),
        child: const Icon(Icons.music_note, color: VibeTuneTheme.textMuted),
      ),
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: img);
    }
    return img;
  }
}

// ─── Section Header ─────────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: VibeTuneTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          if (actionText != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: const TextStyle(
                  color: VibeTuneTheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Artist Card (Grid) ─────────────────────────────────────────────────────────
class ArtistGridCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;

  const ArtistGridCard({super.key, required this.artist, this.onTap});

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
                  // gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: TrendTag(trend: artist.trend),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: VibeTuneTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        artist.genre.toUpperCase(),
                        style: const TextStyle(
                          color: VibeTuneTheme.textMuted,
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      FlameBadge(count: artist.flames, small: true),
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

// ─── Track Row ──────────────────────────────────────────────────────────────────
class TrackRow extends StatelessWidget {
  final Track track;
  final int? rank;

  const TrackRow({super.key, required this.track, this.rank});

  String _formatPlays(int plays) {
    if (plays >= 1000) return '${(plays / 1000).toStringAsFixed(1)}K';
    return plays.toString();
  }

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
            SizedBox(
              width: 28,
              child: Text(
                rank.toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: VibeTuneTheme.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          VibeCachedImage(
            url: track.coverUrl,
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: VibeTuneTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  track.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: VibeTuneTheme.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (track.isNew) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: VibeTuneTheme.neonGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      color: VibeTuneTheme.neonGreen,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                '${_formatPlays(track.plays)} plays',
                style: const TextStyle(
                  color: VibeTuneTheme.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.play_circle_fill,
            color: VibeTuneTheme.primary,
            size: 32,
          ),
        ],
      ),
    );
  }
}

// ─── Vibe Category Chip ─────────────────────────────────────────────────────────
class VibeCategoryChip extends StatelessWidget {
  final VibeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const VibeCategoryChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? category.color.withOpacity(0.2) : VibeTuneTheme.card,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isSelected ? category.color : VibeTuneTheme.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? category.color : VibeTuneTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Chart Row ──────────────────────────────────────────────────────────────
class TopChartArtistRow extends StatelessWidget {
  final Artist artist;
  final int rank;

  const TopChartArtistRow({super.key, required this.artist, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: rank == 1
            ? VibeTuneTheme.primary.withOpacity(0.08)
            : VibeTuneTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: rank == 1
              ? VibeTuneTheme.primary.withOpacity(0.3)
              : VibeTuneTheme.cardBorder,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(
              rank.toString().padLeft(2, '0'),
              style: TextStyle(
                color: rank == 1 ? VibeTuneTheme.primary : VibeTuneTheme.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          VibeCachedImage(
            url: artist.imageUrl,
            width: 44,
            height: 44,
            borderRadius: BorderRadius.circular(22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: VibeTuneTheme.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                Text(
                  artist.genre.toUpperCase(),
                  style: const TextStyle(
                    color: VibeTuneTheme.textMuted,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          FlameBadge(count: artist.flames),
          const SizedBox(width: 8),
          TrendTag(trend: artist.trend),
        ],
      ),
    );
  }
}
