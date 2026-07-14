import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../widgets/widgets.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHARTS',
                    style: TextStyle(
                      color: VibeTuneTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'The hottest in Kenya right now',
                    style: TextStyle(
                      color: VibeTuneTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'ARTISTS'),
                  Tab(text: 'TRACKS'),
                  Tab(text: 'RISING'),
                ],
                labelColor: VibeTuneTheme.primary,
                unselectedLabelColor: VibeTuneTheme.textMuted,
                indicatorColor: VibeTuneTheme.primary,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildArtistChart(),
            _buildTrackChart(),
            _buildRisingChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistChart() {
    final sorted = [...AppData.featuredArtists]
      ..sort((a, b) => b.flames.compareTo(a.flames));
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 40),
      itemCount: sorted.length,
      itemBuilder: (context, i) =>
          TopChartArtistRow(artist: sorted[i], rank: i + 1),
    );
  }

  Widget _buildTrackChart() {
    final all = [...AppData.trendingTracks, ...AppData.freshDrops];
    all.sort((a, b) => b.plays.compareTo(a.plays));
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 40),
      itemCount: all.length,
      itemBuilder: (context, i) => TrackRow(track: all[i], rank: i + 1),
    );
  }

  Widget _buildRisingChart() {
    final rising = AppData.featuredArtists
        .where((a) => a.trend == 'RISING' || a.trend == 'NEW')
        .toList();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 40),
      itemCount: rising.length,
      itemBuilder: (context, i) =>
          TopChartArtistRow(artist: rising[i], rank: i + 1),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: VibeTuneTheme.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
