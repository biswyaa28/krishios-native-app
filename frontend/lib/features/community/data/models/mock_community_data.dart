import '../../domain/models/community_post.dart';

final List<CommunityPost> allPosts = [
  CommunityPost(
    id: 'p1',
    name: 'Elias Thorne',
    role: 'Rice Farmer',
    time: '2h ago',
    isImageAvatar: true,
    title: 'Early signs of stem borer in Field B-4?',
    body:
        'Noticed some minor yellowing and dead hearts on a few stalks this morning. Weather has been unusually humid. Anyone else in the valley seeing similar patterns before I spray?',
    hasImage: true,
    hasShare: true,
    isExpert: false,
    category: 'Pest Control',
  ),
  CommunityPost(
    id: 'p2',
    name: 'Maria Jimenez',
    role: 'Agronomist',
    time: '5h ago',
    isImageAvatar: false,
    initials: 'MJ',
    title: 'Optimal Nitrogen Timing for Late-Season Soy',
    body:
        'A quick reminder for those in Sector 4: given the recent heavy rains, consider delaying your final nitrogen application by 48 hours to prevent runoff. Soil moisture sensors are indicating oversaturation.',
    hasImage: false,
    hasShare: false,
    isExpert: true,
    category: 'Soil Health',
  ),
  CommunityPost(
    id: 'p3',
    name: 'Rajesh Kumar',
    role: 'Wheat Farmer',
    time: '1d ago',
    isImageAvatar: true,
    title: 'Zero-till drill results after first season',
    body:
        'Switched to zero-till drilling for the Rabi season on 2 acres. Initial results show 12% better moisture retention and fewer weed outbreaks compared to conventional tilling. Costs down by roughly \u20B91500/acre.',
    hasImage: true,
    hasShare: true,
    isExpert: false,
    category: 'New Tech',
  ),
  CommunityPost(
    id: 'p4',
    name: 'Priya Sharma',
    role: 'Agri-Economist',
    time: '2d ago',
    isImageAvatar: false,
    initials: 'PS',
    title: 'MSP updates & market trends this quarter',
    body:
        'Government announced revised MSP for Kharif crops. Paddy up by 5.3%, pulses by 7.1%. With global rice demand steady, Q3 projections look favorable for early sellers. Full breakdown in the attached report.',
    hasImage: false,
    hasShare: true,
    isExpert: true,
    category: 'Trending',
  ),
];

final Map<String, int> commentCounts = {
  'p1': 8,
  'p2': 42,
  'p3': 15,
  'p4': 6,
};

final List<String> categoriesList = [
  'Trending',
  'Rice Farmers',
  'Pest Control',
  'New Tech',
  'Soil Health',
];
