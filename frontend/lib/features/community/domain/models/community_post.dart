class CommunityPost {
  final String id;
  final String name;
  final String role;
  final String time;
  final bool isImageAvatar;
  final String? initials;
  final String title;
  final String body;
  final bool hasImage;
  final bool hasShare;
  final bool isExpert;
  final String category;

  CommunityPost({
    required this.id,
    required this.name,
    required this.role,
    required this.time,
    required this.isImageAvatar,
    this.initials,
    required this.title,
    required this.body,
    required this.hasImage,
    required this.hasShare,
    required this.isExpert,
    required this.category,
  });
}
