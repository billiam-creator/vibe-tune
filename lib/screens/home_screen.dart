import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
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
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      final next = (_heroIndex + 1) % _heroSlides.length;
      _heroController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _startAutoPlay();
    });
  }

  @override
  void dispose() {
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
    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHero()),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: SectionHeader(
              title: "THIS WEEK'S TOP 4",
              actionText: 'VIEW FULL RANKINGS →',
              onAction: () {},
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => TopChartArtistRow(
                  artist: AppData.featuredArtists[i], rank: i + 1),
              childCount: 4,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: SectionHeader(
                title: 'TRENDING NOW', actionText: 'SEE ALL →', onAction: () {}),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildTrendingRow()),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: SectionHeader(
                title: 'FRESH DROPS', actionText: 'SEE ALL →', onAction: () {}),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => TrackRow(track: AppData.freshDrops[i]),
              childCount: AppData.freshDrops.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          const SliverToBoxAdapter(
              child: SectionHeader(title: 'SELECT YOUR VIBE')),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverToBoxAdapter(child: _buildVibeCategories()),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: SectionHeader(
                title: 'FEATURED ARTISTS',
                actionText: 'VIEW ALL →',
                onAction: () {}),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverPadding(
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
                    artist: AppData.featuredArtists[i], onTap: () {}),
                childCount: AppData.featuredArtists.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: _buildFooter()),
        ],
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
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          color: VibeTuneTheme.primary,
                          child: const Text(
                            'LIVE SCENE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          slide['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          slide['subtitle']!,
                          style: const TextStyle(
                            color: VibeTuneTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            color: VibeTuneTheme.primary,
                            child: Text(
                              slide['cta']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _heroIndex,
                count: _heroSlides.length,
                effect: const WormEffect(
                  dotWidth: 8,
                  dotHeight: 8,
                  spacing: 6,
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

  Widget _buildTrendingRow() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppData.trendingTracks.length,
        itemBuilder: (context, i) {
          final track = AppData.trendingTracks[i];
          return Container(
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
                VibeCachedImage(url: track.coverUrl, fit: BoxFit.cover),
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
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: VibeTuneTheme.primary,
                    child: const Text('🔥 HOT',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(track.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                      Text(track.artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: VibeTuneTheme.textSecondary, fontSize: 10)),
                    ],
                  ),
                ),
                const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 40),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVibeCategories() {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppData.vibeCategories.length,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: VibeCategoryChip(
            category: AppData.vibeCategories[i],
            isSelected: _selectedVibe == i,
            onTap: () => setState(() => _selectedVibe = i),
          ),
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
              style: TextStyle(
                  color: VibeTuneTheme.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2)),
          const Text('STREET ROOTED',
              style: TextStyle(
                  color: VibeTuneTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 3)),
          const SizedBox(height: 12),
          const Text(
            'The heartbeat of Kenyan music discovery.\nBuilt by the streets, for the world.',
            style: TextStyle(
                color: VibeTuneTheme.textSecondary, fontSize: 12, height: 1.6),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: VibeTuneTheme.cardBorder),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const TextField(
                    style: TextStyle(
                        color: VibeTuneTheme.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Your email',
                      hintStyle: TextStyle(
                          color: VibeTuneTheme.textMuted, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                color: VibeTuneTheme.primary,
                child: const Text('JOIN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('© 2026 VIBE-TUNE - STREET ROOTED.',
              style: TextStyle(
                  color: VibeTuneTheme.textMuted, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}