import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CommentsSheet extends StatefulWidget {
  final String postId;
  final String postTitle;
  final VoidCallback onCommentAdded;

  const CommentsSheet({
    super.key,
    required this.postId,
    required this.postTitle,
    required this.onCommentAdded,
  });

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [
    {
      'name': 'Anil Patel',
      'text': 'I noticed the same in my field last week. Used Neem oil and it helped.',
    },
    {
      'name': 'Sita Devi',
      'text': 'Thanks for sharing this! Very useful information.',
    },
    {
      'name': 'Rohit Singh',
      'text': 'Can you share more details about the application method?',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comments', style: AppTextStyles.headlineMd),
          const SizedBox(height: 4),
          Text(widget.postTitle,
              style: AppTextStyles.bodySm
                  .copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),
          if (_comments.isNotEmpty)
            ..._comments.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        child: Text(c['name']![0],
                            style: AppTextStyles.labelSm),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['name']!, style: AppTextStyles.labelSm),
                            const SizedBox(height: 2),
                            Text(c['text']!, style: AppTextStyles.bodySm),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          const Divider(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          const BorderSide(color: AppColors.outlineVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: () {
                  final text = _commentController.text.trim();
                  if (text.isEmpty) return;
                  setState(() {
                    _comments.add({
                      'name': 'You',
                      'text': text,
                    });
                    _commentController.clear();
                  });
                  widget.onCommentAdded();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
