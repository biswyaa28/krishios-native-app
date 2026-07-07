import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/community_post.dart';

class PostDetailScreen extends StatelessWidget {
  final CommunityPost post;
  final bool isLiked;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const PostDetailScreen({
    super.key,
    required this.post,
    required this.isLiked,
    required this.commentCount,
    required this.onLike,
    required this.onComment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: AppColors.surface,
        scrolledUnderElevation: 0,
        title: Text(post.name, style: AppTextStyles.labelMd),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (post.isImageAvatar)
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        child: Icon(Icons.person,
                            color: AppColors.onSurfaceVariant),
                      )
                    else
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.secondaryContainer,
                        child: Text(post.initials ?? '',
                            style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onSecondaryContainer)),
                      ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.name, style: AppTextStyles.labelMd),
                        Text('${post.role} • ${post.time}',
                            style: AppTextStyles.bodySm),
                      ],
                    ),
                    const Spacer(),
                    if (post.isExpert)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tertiaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Expert Advice',
                            style: AppTextStyles.labelSm.copyWith(
                                color: AppColors.onTertiaryContainer)),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(post.title,
                    style: AppTextStyles.labelMd.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 8),
                Text(post.body, style: AppTextStyles.bodyMd),
                if (post.hasImage) ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image,
                          size: 48, color: AppColors.onSurfaceVariant),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onLike,
                      child: Row(
                        children: [
                          Icon(
                            isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_outlined,
                            size: 20,
                            color: isLiked
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${isLiked ? (commentCount > 0 ? commentCount + 1 : 1) : commentCount}',
                            style: AppTextStyles.labelSm.copyWith(
                              color: isLiked
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: onComment,
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline,
                              size: 20, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text('$commentCount',
                              style: AppTextStyles.labelSm),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
