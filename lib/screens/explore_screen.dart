import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AppState _state = AppState.instance;
  String _query = '';
  int _selectedVibe = -1;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
  }

  void _onStateChange() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    _searchController.dispose();
    super.dispose();
  }

  List<Artist> get _filtered {
    var list = _state.artists.toList();
    if (_selectedVibe >= 0 && _selectedVibe < _state.genres.length) {
      final vibe = _state.genres[_selectedVibe].name.toLowerCase();
      list = list.where((a) => a.genre.toLowerCase().contains(vibe)).toList();
    }
    if (_query.isNotEmpty) {
      list = list.where((a) =>
          a.name.toLowerCase().contains(_query.toLowerCase()) ||
          a.genre.toLowerCase().contains(_query.toLowerCase())).toList();
    }
    return list;
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
    final filtered = _filtered;
    final genres = _state.genres;

    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: RefreshIndicator(
        color: VibeTuneTheme.primary,
        backgroundColor: VibeTuneTheme.card,
        onRefresh: _state.loadArtists,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('EXPLORE',
                        style: TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 4),
                    const Text('Discover the next big sound from Kenya',
                        style: TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 13)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: VibeTuneTheme.card,
                        border: Border.all(color: VibeTuneTheme.cardBorder),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: VibeTuneTheme.textMuted, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (v) => setState(() => _query = v),
                              style: const TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 14),
                              decoration: const InputDecoration(
                                hintText: 'Search artists, genres...',
                                hintStyle: TextStyle(color: VibeTuneTheme.textMuted, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () { _searchController.clear(); setState(() => _query = ''); },
                              child: const Icon(Icons.close, color: VibeTuneTheme.textMuted, size: 18),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 46,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: genres.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedVibe = -1),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: _selectedVibe == -1 ? VibeTuneTheme.primary.withOpacity(0.2) : VibeTuneTheme.card,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: _selectedVibe == -1 ? VibeTuneTheme.primary : VibeTuneTheme.cardBorder),
                            ),
                            child: Text('ALL',
                                style: TextStyle(
                                  color: _selectedVibe == -1 ? VibeTuneTheme.primary : VibeTuneTheme.textSecondary,
                                  fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1,
                                )),
                          ),
                        ),
                      );
                    }
                    final genre = genres[i - 1];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedVibe = i - 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedVibe == i - 1 ? genre.color.withOpacity(0.2) : VibeTuneTheme.card,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _selectedVibe == i - 1 ? genre.color : VibeTuneTheme.cardBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(genre.emoji, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(genre.name.toUpperCase(),
                                  style: TextStyle(
                                    color: _selectedVibe == i - 1 ? genre.color : VibeTuneTheme.textSecondary,
                                    fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('${filtered.length} ARTIST${filtered.length != 1 ? 'S' : ''} FOUND',
                    style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
              ),
            ),
            _state.loadingArtists
                ? SliverToBoxAdapter(child: const Center(child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: VibeTuneTheme.primary))))
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridColumns(context),
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 10, mainAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ArtistGridCard(
                          artist: filtered[i],
                          onTap: () {},
                          onFlame: () => _state.toggleArtistFlame(filtered[i]),
                        ),
                        childCount: filtered.length,
                      ),
                    ),
                  ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}