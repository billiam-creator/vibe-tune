import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../services/player_controller.dart';
import 'widgets.dart';

class NowPlayingBar extends StatefulWidget {
  const NowPlayingBar({super.key});

  @override
  State<NowPlayingBar> createState() => _NowPlayingBarState();
}

class _NowPlayingBarState extends State<NowPlayingBar> {
  final PlayerController _player = PlayerController.instance;

  @override
  void initState() {
    super.initState();
    _player.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    _player.removeListener(_onChange);
    super.dispose();
  }

  int? _durationSeconds() {
    final d = _player.currentTrack?.duration;
    if (d == null || !d.contains(':')) return null;
    final parts = d.split(':');
    if (parts.length != 2) return null;
    final min = int.tryParse(parts[0]) ?? 0;
    final sec = int.tryParse(parts[1]) ?? 0;
    return min * 60 + sec;
  }

  @override
  Widget build(BuildContext context) {
    final track = _player.currentTrack;
    if (track == null) return const SizedBox.shrink();

    final duration = _durationSeconds() ?? 180;
    final progress = _player.progressSeconds.clamp(0, duration);

    return Container(
      decoration: const BoxDecoration(
        color: VibeTuneTheme.surface,
        border: Border(top: BorderSide(color: VibeTuneTheme.divider)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: progress.toDouble(),
              min: 0,
              max: duration.toDouble(),
              activeColor: VibeTuneTheme.primary,
              inactiveColor: VibeTuneTheme.divider,
              onChanged: (v) => _player.seek(v.toInt()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                VibeCachedImage(
                  url: track.imageUrl,
                  width: 44,
                  height: 44,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: VibeTuneTheme.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                      Text(
                        track.artistName.isNotEmpty ? track.artistName : (_player.loading ? 'Loading preview…' : (_player.isSpotifyPreview ? 'Spotify Preview' : 'Simulated Playback')),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                if (track.youtubeUrl != null && track.youtubeUrl!.isNotEmpty)
                  IconButton(
                    tooltip: 'Watch on YouTube',
                    onPressed: () async {
                      final uri = Uri.tryParse(track.youtubeUrl!);
                      if (uri != null) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    icon: const Icon(Icons.smart_display_outlined, color: VibeTuneTheme.textSecondary, size: 20),
                  ),
                IconButton(
                  onPressed: _player.previous,
                  icon: const Icon(Icons.skip_previous, color: VibeTuneTheme.textPrimary),
                ),
                _player.loading
                    ? const SizedBox(
                        width: 32,
                        height: 32,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: CircularProgressIndicator(strokeWidth: 2, color: VibeTuneTheme.primary),
                        ),
                      )
                    : IconButton(
                        onPressed: _player.togglePlay,
                        icon: Icon(
                          _player.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                          color: VibeTuneTheme.primary,
                          size: 34,
                        ),
                      ),
                IconButton(
                  onPressed: _player.next,
                  icon: const Icon(Icons.skip_next, color: VibeTuneTheme.textPrimary),
                ),
                IconButton(
                  onPressed: _player.close,
                  icon: const Icon(Icons.close, color: VibeTuneTheme.textMuted, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}