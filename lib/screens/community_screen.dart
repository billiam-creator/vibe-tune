import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static const List<Map<String, String>> _posts = [
    {
      'user': 'NairobiDrillFan',
      'avatar': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/1000702973_fZhghUXTj.jpg',
      'time': '2 hours ago',
      'content':
          'Just saw WAKADINALI live in Eastlands last night 🔥 The energy was unmatched bro. Real street music for real people.',
      'likes': '342',
      'replies': '28',
      'tag': 'LIVE REVIEW',
    },
    {
      'user': 'GengetoneLover254',
      'avatar': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/1000690978_W3x3JegNr.jpg',
      'time': '5 hours ago',
      'content':
          'EMILYO AYUB\'s new track is different different. 8 flames is an understatement. This guy is about to blow up internationally.',
      'likes': '218',
      'replies': '45',
      'tag': 'HOT TAKE',
    },
    {
      'user': 'StreetScout_KE',
      'avatar': 'https://ik.imagekit.io/26z9hpwtg/vibetune_uploads/1000684394_HUWRIlsZk.jpg',
      'time': '1 day ago',
      'content':
          'The Nairobi Drill scene is evolving so fast. JACKPIN SAMURAI and 4MR Frank White collab when? Drop a 🔥 if you want this to happen.',
      'likes': '567',
      'replies': '89',
      'tag': 'DISCUSSION',
    },
    {
      'user': 'UndagroundRadio',
      'avatar': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/deadbeat_Ds6KLinSd.jpeg',
      'time': '2 days ago',
      'content':
          'dEADbEATTT is doing things nobody expected from Kenyan music. Dark, experimental, and raw. This is the sound of tomorrow.',
      'likes': '134',
      'replies': '19',
      'tag': 'DEEP DIVE',
    },
    {
      'user': 'WapiMchezo',
      'avatar': 'https://ik.imagekit.io/nwsbzz0pe/vibetune/1000691302_S-nvvHTpB.jpg',
      'time': '3 days ago',
      'content':
          'CO SIGN BLACK has been consistent for 3 years straight without any label backing. This is what independent music looks like. Respect.',
      'likes': '445',
      'replies': '62',
      'tag': 'RESPECT',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMMUNITY',
                    style: TextStyle(
                      color: VibeTuneTheme.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Join the conversation. Be part of the wave.',
                    style: TextStyle(
                      color: VibeTuneTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Post composer
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: VibeTuneTheme.card,
                      border: Border.all(color: VibeTuneTheme.cardBorder),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: VibeTuneTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Drop your vibe here...',
                            style: TextStyle(
                                color: VibeTuneTheme.textMuted, fontSize: 14),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          color: VibeTuneTheme.primary,
                          child: const Text(
                            'POST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Community stats
                  Row(
                    children: [
                      _buildStat('12.4K', 'MEMBERS'),
                      const SizedBox(width: 24),
                      _buildStat('3.2K', 'POSTS'),
                      const SizedBox(width: 24),
                      _buildStat('89', 'ONLINE NOW'),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => _buildPost(_posts[i]),
              childCount: _posts.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: VibeTuneTheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: VibeTuneTheme.textMuted,
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPost(Map<String, String> post) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: VibeTuneTheme.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VibeTuneTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  post['avatar']!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 36,
                    height: 36,
                    color: VibeTuneTheme.primary,
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['user']!,
                      style: const TextStyle(
                        color: VibeTuneTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      post['time']!,
                      style: const TextStyle(
                        color: VibeTuneTheme.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: VibeTuneTheme.primary.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(2),
                  color: VibeTuneTheme.primary.withOpacity(0.1),
                ),
                child: Text(
                  post['tag']!,
                  style: const TextStyle(
                    color: VibeTuneTheme.primary,
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            post['content']!,
            style: const TextStyle(
              color: VibeTuneTheme.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildAction(Icons.favorite_border, post['likes']!),
              const SizedBox(width: 20),
              _buildAction(Icons.chat_bubble_outline, post['replies']!),
              const SizedBox(width: 20),
              _buildAction(Icons.share, ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: VibeTuneTheme.textMuted, size: 16),
        if (count.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(
            count,
            style: const TextStyle(
              color: VibeTuneTheme.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
