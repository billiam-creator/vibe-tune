import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int _selectedVibe = -1;

  List<Artist> get _filtered {
    var list = AppData.featuredArtists.toList();
    if (_selectedVibe >= 0) {
      final vibe = AppData.vibeCategories[_selectedVibe].name.toLowerCase();
      list = list
          .where((a) =>
              a.tags.any((t) => t.toLowerCase().contains(vibe)) ||
              a.genre.toLowerCase().contains(vibe))
          .toList();
    }
    if (_query.isNotEmpty) {
      list = list
          .where((a) =>
              a.name.toLowerCase().contains(_query.toLowerCase()) ||
              a.genre.toLowerCase().contains(_query.toLowerCase()))
          .toList();
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
    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EXPLORE',
                    style: TextStyle(
                      color: VibeTuneTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Discover the next big sound from Kenya',
                    style: TextStyle(
                      color: VibeTuneTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: VibeTuneTheme.card,
                      border: Border.all(color: VibeTuneTheme.cardBorder),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: VibeTuneTheme.textMuted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            style: const TextStyle(
                                color: VibeTuneTheme.textPrimary, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Search artists, genres...',
                              hintStyle: TextStyle(
                                  color: VibeTuneTheme.textMuted, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(Icons.close,
                                color: VibeTuneTheme.textMuted, size: 18),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Vibe filter chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: AppData.vibeCategories.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedVibe = -1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: _selectedVibe == -1
                                ? VibeTuneTheme.primary.withOpacity(0.2)
                                : VibeTuneTheme.card,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _selectedVibe == -1
                                  ? VibeTuneTheme.primary
                                  : VibeTuneTheme.cardBorder,
                            ),
                          ),
                          child: Text(
                            'ALL',
                            style: TextStyle(
                              color: _selectedVibe == -1
                                  ? VibeTuneTheme.primary
                                  : VibeTuneTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: VibeCategoryChip(
                      category: AppData.vibeCategories[i - 1],
                      isSelected: _selectedVibe == i - 1,
                      onTap: () => setState(() => _selectedVibe = i - 1),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          // Result count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                '${filtered.length} ARTIST${filtered.length != 1 ? 'S' : ''} FOUND',
                style: const TextStyle(
                  color: VibeTuneTheme.textMuted,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          // Grid
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
                (context, i) =>
                    ArtistGridCard(artist: filtered[i], onTap: () {}),
                childCount: filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
