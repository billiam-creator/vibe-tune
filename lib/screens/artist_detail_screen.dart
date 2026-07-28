import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/app_state.dart';
import '../widgets/widgets.dart';

/// Mobile counterpart to the website's ArtistDetailView — shows the artist's
/// bio, flame count (with the same toggle everywhere else uses), links out
/// to Spotify/YouTube, and lists every track by this artist with working
/// play/like buttons.
class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;
  const ArtistDetailScreen({super.key, required this.artist});

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final AppState _state = AppState.instance;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
  }

  void _onStateChange() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    super.dispose();
  }

  // Re-reads the artist from AppState (by id) so likes toggled elsewhere —
  // or on this screen — stay in sync, instead of using a stale snapshot.
  Artist get _artist =>
      _state.artists.firstWhere((a) => a.id == widget.artist.id, orElse: () => widget.artist);

  @override
  Widget build(BuildContext context) {
    final artist = _artist;
    final tracks = _state.tracks.where((t) => t.artistId == artist.id).toList()
      ..sort((a, b) => b.playCount.compareTo(a.playCount));

    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: VibeTuneTheme.background,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  VibeCachedImage(url: artist.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.3), VibeTuneTheme.background],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20, right: 20, bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          color: VibeTuneTheme.primary,
                          child: Text(artist.genre.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                        ),
                        const SizedBox(height: 10),
                        Text(artist.name,
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, height: 1.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _state.toggleArtistFlame(artist),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: artist.isLiked ? VibeTuneTheme.primary : VibeTuneTheme.card,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: VibeTuneTheme.primary),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('🔥', style: TextStyle(fontSize: 15)),
                              const SizedBox(width: 6),
                              Text('${artist.flameCount}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (artist.spotifyUrl != null && artist.spotifyUrl!.isNotEmpty)
                        IconButton(
                          tooltip: 'Open on Spotify',
                          onPressed: () => _openLink(artist.spotifyUrl!),
                          icon: const Icon(Icons.album_outlined, color: VibeTuneTheme.textSecondary),
                        ),
                      if (artist.youtubeUrl != null && artist.youtubeUrl!.isNotEmpty)
                        IconButton(
                          tooltip: 'Open on YouTube',
                          onPressed: () => _openLink(artist.youtubeUrl!),
                          icon: const Icon(Icons.smart_display_outlined, color: VibeTuneTheme.textSecondary),
                        ),
                    ],
                  ),
                  if (artist.bio != null && artist.bio!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(artist.bio!,
                        style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 14, height: 1.5)),
                  ],
                  const SizedBox(height: 28),
                  const Text('TRACKS',
                      style: TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                ],
              ),
            ),
          ),
          if (_state.loadingTracks)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator(color: VibeTuneTheme.primary)),
              ),
            )
          else if (tracks.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text('No tracks from this artist yet.',
                      style: TextStyle(color: VibeTuneTheme.textMuted)),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => TrackRow(
                  track: tracks[i],
                  onPlay: () => _state.playTrack(tracks[i], queue: tracks),
                  onLike: () => _state.toggleTrackLike(tracks[i]),
                ),
                childCount: tracks.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}