import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/community_post.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final bool isLiked;
  final int commentCount;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onShare;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.commentCount,
    required this.onLike,
    required this.onComment,
    this.onShare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.surfaceVariant),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      post.initials ?? '',
                      style: AppTextStyles.labelMd
                          .copyWith(color: AppColors.onSecondaryContainer),
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.name, style: AppTextStyles.labelMd),
                      Text('${post.role} • ${post.time}',
                          style: AppTextStyles.bodySm),
                    ],
                  ),
                ),
                if (post.isExpert)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Expert Advice',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onTertiaryContainer,
                      ),
                    ),
                  )
                else
                  const Icon(Icons.more_vert,
                      color: AppColors.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.title,
                style: AppTextStyles.labelMd.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )),
            const SizedBox(height: 4),
            Text(post.body, style: AppTextStyles.bodyMd),
            if (post.hasImage) ...[
              const SizedBox(height: 12),
              Container(
                height: 192,
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
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: onLike,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onComment,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chat_bubble_outline,
                          size: 20, color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '$commentCount',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onShare != null) const Spacer(),
                if (onShare != null)
                  GestureDetector(
                    onTap: onShare,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.share_outlined,
                            size: 20, color: AppColors.onSurfaceVariant),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
