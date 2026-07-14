import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../theme/app_theme.dart';
import '../services/app_state.dart';
import '../models/models.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final AppState _state = AppState.instance;
  final TextEditingController _postController = TextEditingController();
  bool _posting = false;

  @override
  void initState() {
    super.initState();
    _state.addListener(_onStateChange);
  }

  void _onStateChange() => setState(() {});

  @override
  void dispose() {
    _state.removeListener(_onStateChange);
    _postController.dispose();
    super.dispose();
  }

  Future<void> _handlePost() async {
    final text = _postController.text.trim();
    if (text.isEmpty) return;

    if (_state.userProfile == null) {
      _showProfileSetup();
      return;
    }

    setState(() => _posting = true);
    final success = await _state.postComment(text);
    setState(() => _posting = false);

    if (success) {
      _postController.clear();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post. Try again.'), backgroundColor: VibeTuneTheme.primary),
        );
      }
    }
  }

  void _showProfileSetup() {
    final nameCtrl = TextEditingController();
    final handleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: VibeTuneTheme.card,
        title: const Text('SET YOUR VIBE PROFILE',
            style: TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a username to drop your takes.',
                style: TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 16),
            _inputField(nameCtrl, 'Username (e.g. VibeKing)'),
            const SizedBox(height: 8),
            _inputField(handleCtrl, 'Handle (e.g. @vibek)'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL', style: TextStyle(color: VibeTuneTheme.textMuted)),
          ),
          GestureDetector(
            onTap: () async {
              if (nameCtrl.text.isEmpty || handleCtrl.text.isEmpty) return;
              final handle = handleCtrl.text.startsWith('@') ? handleCtrl.text : '@${handleCtrl.text}';
              await _state.saveProfile(nameCtrl.text, handle);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: VibeTuneTheme.primary,
              child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: VibeTuneTheme.cardBorder),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 13),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VibeTuneTheme.background,
      body: RefreshIndicator(
        color: VibeTuneTheme.primary,
        backgroundColor: VibeTuneTheme.card,
        onRefresh: _state.loadComments,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('COMMUNITY',
                        style: TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 4),
                    const Text('Join the conversation. Be part of the wave.',
                        style: TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 13)),
                    const SizedBox(height: 20),
                    // Stats
                    Row(
                      children: [
                        _buildStat('${_state.comments.length}', 'POSTS'),
                        const SizedBox(width: 24),
                        _buildStat('${_state.artists.length}', 'ARTISTS'),
                        const SizedBox(width: 24),
                        _buildStat('LIVE', 'STATUS'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Composer
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: VibeTuneTheme.card,
                        border: Border.all(color: VibeTuneTheme.cardBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: const BoxDecoration(color: VibeTuneTheme.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.person, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _postController,
                                  maxLines: 2,
                                  minLines: 1,
                                  style: const TextStyle(color: VibeTuneTheme.textPrimary, fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: _state.userProfile != null
                                        ? 'Drop your vibe, ${_state.userProfile}...'
                                        : 'Drop your vibe here...',
                                    hintStyle: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 13),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_state.userProfile == null)
                                GestureDetector(
                                  onTap: _showProfileSetup,
                                  child: const Text('Set profile first →',
                                      style: TextStyle(color: VibeTuneTheme.textMuted, fontSize: 11)),
                                ),
                              const Spacer(),
                              GestureDetector(
                                onTap: _posting ? null : _handlePost,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  color: _posting ? VibeTuneTheme.textMuted : VibeTuneTheme.primary,
                                  child: _posting
                                      ? const SizedBox(width: 16, height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : const Text('POST',
                                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _state.loadingComments
                ? SliverToBoxAdapter(
                    child: Column(
                      children: List.generate(4, (_) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        height: 100,
                        decoration: BoxDecoration(color: VibeTuneTheme.card, borderRadius: BorderRadius.circular(8)),
                      )),
                    ),
                  )
                : _state.comments.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: Text('No posts yet. Be the first to drop a vibe! 🔥',
                                style: TextStyle(color: VibeTuneTheme.textMuted, fontSize: 13), textAlign: TextAlign.center),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => _buildPost(_state.comments[i]),
                          childCount: _state.comments.length,
                        ),
                      ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(color: VibeTuneTheme.primary, fontSize: 18, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildPost(Comment comment) {
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
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: VibeTuneTheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: VibeTuneTheme.primary.withOpacity(0.4)),
                ),
                child: Center(
                  child: Text(
                    comment.username.isNotEmpty ? comment.username[0].toUpperCase() : 'V',
                    style: const TextStyle(color: VibeTuneTheme.primary, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.username,
                        style: const TextStyle(color: VibeTuneTheme.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                    Text('${comment.handle} · ${timeago.format(comment.createdDate)}',
                        style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 10)),
                  ],
                ),
              ),
              if (comment.trackId != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: VibeTuneTheme.primary.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(2),
                    color: VibeTuneTheme.primary.withOpacity(0.1),
                  ),
                  child: const Text('TRACK', style: TextStyle(color: VibeTuneTheme.primary, fontSize: 8, fontWeight: FontWeight.w900)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(comment.text,
              style: const TextStyle(color: VibeTuneTheme.textSecondary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => _state.toggleCommentLike(comment),
                child: Row(
                  children: [
                    Icon(
                      comment.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: comment.isLiked ? VibeTuneTheme.primary : VibeTuneTheme.textMuted,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text('${comment.likes}',
                        style: const TextStyle(color: VibeTuneTheme.textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}