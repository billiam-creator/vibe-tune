import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _heroController = PageController();
  int _heroIndex = 0;
  int _selectedVibe = 0;
  final AppState _state = AppState.instance;

  final List<Map<String, String>> _heroSlides = [
    {
      'title': 'WHERE KENYAN\nMUSIC LIVES',
      'subtitle': 'Uncover Kenya\'s Rising Underground Artists.',
      'cta': 'EXPLORE NOW',
      'image': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/1000690978_W3x3JegNr.jpg',
    },
    {
      'title': 'THE WAVE IS\nHERE',
      'subtitle': 'Book talent for your next video shoot.',
      'cta': 'BOOK TALENT',
      'image': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/2e528f18-fce9-4d63-a17a-625149463c2a-1_all_8437_BE5ZBJgta.jpg',
    },
    {
      'title': 'STREET\nROOTED',
      'subtitle': 'Built by the streets, for the world.',
      'cta': 'JOIN THE SCENE',
      'image': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/1000702973_fZhghUXTj.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
    _startAutoPlay();
  }

  void _onStateChange() => setState(() {});

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      final next = (_heroIndex + 1) % _heroSlides.length;
      _heroController.animateToPage(next,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    _heroController.dispose();
    super.dispose();
  }

  int _gridColumns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1200) return 6;
    if (w >= 900) return 5;
    if (w >= 600) return 4;
    if (w >= 400) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final topArtists = _state.topArtists;
    final trending = _state.trendingTracks;
    final fresh = _state.freshDrops;
    final genres = _state.genres;
    final allArtists = _state.artists;

    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: RefreshIndicator(
        color: VibeTuneTheme.primary,
        backgroundColor: VibeTuneTheme.card,
        onRefresh: () => Future.wait([
          _state.loadArtists(),
          _state.loadTracks(),
        ]),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero()),

            // TOP 4
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: "THIS WEEK'S TOP 4",
                actionText: 'VIEW FULL RANKINGS →',
                onAction: () {},
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            _state.loadingArtists
                ? SliverToBoxAdapter(child: _buildShimmerList(4))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => TopChartArtistRow(
                        artist: topArtists[i],
                        rank: i + 1,
                        onFlame: () => _state.toggleArtistFlame(topArtists[i]),
                      ),
                      childCount: topArtists.length,
                    ),
                  ),

            // TRENDING
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: SectionHeader(title: 'TRENDING NOW', actionText: 'SEE ALL →', onAction: () {}),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: _state.loadingTracks
                  ? _buildShimmerRow()
                  : _buildTrendingRow(trending),
            ),

            // FRESH DROPS
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: SectionHeader(title: 'FRESH DROPS', actionText: 'SEE ALL →', onAction: () {}),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            _state.loadingTracks
                ? SliverToBoxAdapter(child: _buildShimmerList(4))
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => TrackRow(
                        track: fresh[i],
                        onPlay: () => _state.playTrack(fresh[i]),
                        onLike: () => _state.toggleTrackLike(fresh[i]),
                      ),
                      childCount: fresh.length,
                    ),
                  ),

            // VIBE CATEGORIES
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            const SliverToBoxAdapter(child: SectionHeader(title: 'SELECT YOUR VIBE')),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _buildVibeCategories(genres)),

            // FEATURED ARTISTS
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: SectionHeader(title: 'FEATURED ARTISTS', actionText: 'VIEW ALL →', onAction: () {}),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            _state.loadingArtists
                ? SliverToBoxAdapter(child: _buildShimmerGrid(context))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridColumns(context),
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ArtistGridCard(
                          artist: allArtists[i],
                          onTap: () {},
                          onFlame: () => _state.toggleArtistFlame(allArtists[i]),
                        ),
                        childCount: allArtists.length,
                      ),
                    ),
                  ),

            SliverToBoxAdapter(child: _buildFooter()),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 520,
      child: Stack(
        children: [
          PageView.builder(
            controller: _heroController,
            onPageChanged: (i) => setState(() => _heroIndex = i),
            itemCount: _heroSlides.length,
            itemBuilder: (context, i) {
              final slide = _heroSlides[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  VibeCachedImage(url: slide['image']!, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.85)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60, left: 20, right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: VibeTuneTheme.primary,
                          child: const Text('LIVE SCENE',
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        ),
                        const SizedBox(height: 12),
                        Text(slide['title']!,
                            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1)),
                        const SizedBox(height: 10),
                        Text(slide['subtitle']!,
                            style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 14)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          color: VibeTuneTheme.primary,
                          child: Text(slide['cta']!,
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 20, left: 0, right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _heroIndex,
                count: _heroSlides.length,
                effect: const WormEffect(
                  dotWidth: 8, dotHeight: 8, spacing: 6,
                  activeDotColor: VibeTuneTheme.primary,
                  dotColor: Color(0xFF333333),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingRow(List<Track> tracks) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tracks.length,
        itemBuilder: (context, i) {
          final track = tracks[i];
          return GestureDetector(
            onTap: () => _state.playTrack(track),
            child: Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: VibeTuneTheme.cardBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VibeCachedImage(url: track.imageUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      color: VibeTuneTheme.primary,
                      child: const Text('🔥 HOT',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900)),
                    ),
                  ),
                  Positioned(
                    bottom: 10, left: 10, right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                        Text(track.artistName, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 10)),
                        Text(track.formattedPlays + ' plays',
                            style: const TextStyle(color: VibeTuneTheme.accent, fontSize: 9, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVibeCategories(List<VibeGenre> genres) {
    final display = genres.isNotEmpty
        ? genres
        : [
            VibeGenre(id: '1', name: 'Gengetone'),
            VibeGenre(id: '2', name: 'Nairobi Drill'),
            VibeGenre(id: '3', name: 'Afro Trap'),
            VibeGenre(id: '4', name: 'House'),
            VibeGenre(id: '5', name: 'R&B'),
          ];
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: display.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedVibe = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedVibe == i ? display[i].color.withOpacity(0.2) : VibeTuneTheme.card,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _selectedVibe == i ? display[i].color : VibeTuneTheme.cardBorder,
                  width: _selectedVibe == i ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(display[i].emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(display[i].name.toUpperCase(),
                      style: TextStyle(
                        color: _selectedVibe == i ? display[i].color : VibeTuneTheme.textSecondary,
                        fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerList(int count) {
    return Column(
      children: List.generate(count, (_) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        height: 68,
        decoration: BoxDecoration(color: VibeTuneTheme.card, borderRadius: BorderRadius.circular(8)),
      )),
    );
  }

  Widget _buildShimmerRow() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 4,
        itemBuilder: (_, __) => Container(
          width: 160, height: 200,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(color: VibeTuneTheme.card, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridColumns(context),
          childAspectRatio: 0.72,
          crossAxisSpacing: 10, mainAxisSpacing: 10,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => Container(
          decoration: BoxDecoration(color: VibeTuneTheme.card, borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: VibeTuneTheme.surface,
        border: Border(top: BorderSide(color: VibeTuneTheme.divider)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('VIBE-TUNE',
              style: TextStyle(color: VibeTuneTheme.primary, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const Text('STREET ROOTED',
              style: TextStyle(color: VibeTuneTheme.textMuted, fontSize: 10, letterSpacing: 3)),
          const SizedBox(height: 12),
          const Text('The heartbeat of Kenyan music discovery.\nBuilt by the streets, for the world.',
              style: TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 12, height: 1.6)),
          const SizedBox(height: 24),
          const Text('© 2026 VIBE-TUNE - STREET ROOTED.',
              style: TextStyle(color: VibeTuneTheme.textMuted, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}