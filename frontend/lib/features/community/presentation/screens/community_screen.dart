import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/community_post.dart';
import '../../data/models/mock_community_data.dart';
import '../widgets/community_search_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/post_card.dart';
import '../widgets/comments_sheet.dart';
import '../widgets/share_sheet.dart';
import 'post_detail_screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Trending';
  final Set<String> _likedPosts = {};
  final TextEditingController _searchController = TextEditingController();
  
  late final List<CommunityPost> _allPosts = List.from(allPosts);
  late final Map<String, int> _commentCounts = Map.from(commentCounts);

  List<CommunityPost> get _filteredPosts {
    var posts = _allPosts;
    if (_selectedCategory != 'Trending') {
      posts = posts.where((p) => p.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      posts = posts
          .where((p) =>
              p.title.toLowerCase().contains(query) ||
              p.body.toLowerCase().contains(query) ||
              p.name.toLowerCase().contains(query))
          .toList();
    }
    return posts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final posts = _filteredPosts;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 100 + bottomInset),
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryContainer.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        const Icon(Icons.agriculture,
                            color: AppColors.primary, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'KrishiOS',
                          style: AppTextStyles.headlineMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CommunitySearchBar(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
            const SizedBox(height: 16),
            CategoryChips(
              categories: categoriesList,
              selected: _selectedCategory,
              onSelected: (cat) => setState(() => _selectedCategory = cat),
            ),
            const SizedBox(height: 20),
            if (posts.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off,
                          size: 48, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text('No posts found',
                          style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              )
            else
              ...posts.map((post) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PostCard(
                      post: post,
                      isLiked: _likedPosts.contains(post.id),
                      commentCount: _commentCounts[post.id] ?? 0,
                      onLike: () => _toggleLike(post.id),
                      onComment: () => _showComments(context, post),
                      onShare: post.hasShare ? () => _showShareSheet(context, post) : null,
                      onTap: () => _openPostDetail(context, post),
                    ),
                  )),
          ],
        ),
        Positioned(
          bottom: 80 + bottomInset + 16,
          right: 16,
          child: SizedBox(
            width: 56,
            height: 56,
            child: FloatingActionButton(
              onPressed: () => _showCreatePost(context),
              backgroundColor: AppColors.primaryContainer,
              foregroundColor: AppColors.onPrimaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.edit, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleLike(String postId) {
    setState(() {
      if (_likedPosts.contains(postId)) {
        _likedPosts.remove(postId);
      } else {
        _likedPosts.add(postId);
      }
    });
  }

  void _showComments(BuildContext context, CommunityPost post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => CommentsSheet(
        postId: post.id,
        postTitle: post.title,
        onCommentAdded: () {
          setState(() {
            _commentCounts[post.id] = (_commentCounts[post.id] ?? 0) + 1;
          });
        },
      ),
    );
  }

  void _showShareSheet(BuildContext context, CommunityPost post) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => ShareSheet(post: post),
    );
  }

  void _openPostDetail(BuildContext context, CommunityPost post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          post: post,
          isLiked: _likedPosts.contains(post.id),
          commentCount: _commentCounts[post.id] ?? 0,
          onLike: () => _toggleLike(post.id),
          onComment: () => _showComments(context, post),
        ),
      ),
    );
  }

  void _showCreatePost(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    String selectedCategory = categoriesList[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create Post', style: AppTextStyles.headlineMd),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: selectedCategory,
              items: categoriesList
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => selectedCategory = v ?? categoriesList[0],
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bodyController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _addPost(
                    category: selectedCategory,
                    title: titleController.text,
                    body: bodyController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text('Post'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _addPost({
    required String category,
    required String title,
    required String body,
  }) {
    if (title.isEmpty || body.isEmpty) return;
    final newPost = CommunityPost(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'You',
      role: 'Farmer',
      time: 'Just now',
      isImageAvatar: false,
      initials: 'YO',
      title: title,
      body: body,
      hasImage: false,
      hasShare: true,
      isExpert: false,
      category: category,
    );
    setState(() {
      _allPosts.insert(0, newPost);
      _commentCounts[newPost.id] = 0;
    });
  }
}
