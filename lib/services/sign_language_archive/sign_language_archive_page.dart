import 'package:flutter/material.dart';
import 'sign_video_detail_page.dart';

/// SignLanguageArchivePage displays a collection of sign language videos
class SignLanguageArchivePage extends StatefulWidget {
  const SignLanguageArchivePage({super.key});

  @override
  State<SignLanguageArchivePage> createState() => _SignLanguageArchivePageState();
}

class _SignLanguageArchivePageState extends State<SignLanguageArchivePage> with TickerProviderStateMixin {
  List<Map<String, dynamic>> _signVideos = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _loadVideos();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  /// Load video files from assets
  Future<void> _loadVideos() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate a brief loading delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Get video files and map them to display information
      // In a real app, this would come from a database with proper metadata
      _signVideos = [
        {
          'title': 'Hello',
          'description': 'Sign for greeting someone',
          'videoPath': 'assets/videos/VID-20250505-WA0081.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Greetings',
          'difficulty': 'Easy',
        },
        {
          'title': 'Thank You',
          'description': 'Sign for expressing gratitude',
          'videoPath': 'assets/videos/VID-20250505-WA0082.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Common Phrases',
          'difficulty': 'Easy',
        },
        {
          'title': 'Please',
          'description': 'Sign for making a polite request',
          'videoPath': 'assets/videos/VID-20250505-WA0083.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Common Phrases',
          'difficulty': 'Easy',
        },
        {
          'title': 'Yes',
          'description': 'Sign for affirmation',
          'videoPath': 'assets/videos/VID-20250505-WA0084.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Responses',
          'difficulty': 'Easy',
        },
        {
          'title': 'No',
          'description': 'Sign for negation',
          'videoPath': 'assets/videos/VID-20250505-WA0085.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Responses',
          'difficulty': 'Easy',
        },
        {
          'title': 'Help',
          'description': 'Sign for requesting assistance',
          'videoPath': 'assets/videos/VID-20250505-WA0086.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Emergency',
          'difficulty': 'Medium',
        },
        {
          'title': 'Family',
          'description': 'Sign representing family',
          'videoPath': 'assets/videos/VID-20250505-WA0087.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Relationships',
          'difficulty': 'Medium',
        },
        {
          'title': 'Friend',
          'description': 'Sign for a friend',
          'videoPath': 'assets/videos/VID-20250505-WA0088.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Relationships',
          'difficulty': 'Medium',
        },
        {
          'title': 'Love',
          'description': 'Sign expressing love',
          'videoPath': 'assets/videos/VID-20250505-WA0089.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Emotions',
          'difficulty': 'Medium',
        },
        {
          'title': 'Happy',
          'description': 'Sign for happiness',
          'videoPath': 'assets/videos/VID-20250505-WA0090.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Emotions',
          'difficulty': 'Easy',
        },
        {
          'title': 'Sad',
          'description': 'Sign for sadness',
          'videoPath': 'assets/videos/VID-20250505-WA0091.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Emotions',
          'difficulty': 'Easy',
        },
        {
          'title': 'Sorry',
          'description': 'Sign for apologizing',
          'videoPath': 'assets/videos/VID-20250505-WA0092.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Common Phrases',
          'difficulty': 'Medium',
        },
        {
          'title': 'Food',
          'description': 'Sign for food',
          'videoPath': 'assets/videos/VID-20250505-WA0093.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Basic Needs',
          'difficulty': 'Medium',
        },
        {
          'title': 'Water',
          'description': 'Sign for water',
          'videoPath': 'assets/videos/VID-20250505-WA0094.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Basic Needs',
          'difficulty': 'Easy',
        },
        {
          'title': 'Home',
          'description': 'Sign for home',
          'videoPath': 'assets/videos/VID-20250505-WA0095.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Places',
          'difficulty': 'Medium',
        },
        {
          'title': 'School',
          'description': 'Sign for school',
          'videoPath': 'assets/videos/VID-20250505-WA0096.mp4',
          'thumbnail': 'assets/logo.jpg',
          'category': 'Places',
          'difficulty': 'Medium',
        },
      ];
      
      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading videos: $e');
      setState(() {
        _isLoading = false;
        _signVideos = [];
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load videos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Filter videos by category
  List<Map<String, dynamic>> _getVideosByCategory(String category) {
    return _signVideos.where((video) => video['category'] == category).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Language Archive',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1.0 + 0.1 * _animationController.value,
                        child: Icon(
                          Icons.sign_language,
                          size: 80,
                          color: Colors.orange.withOpacity(0.8),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Loading Sign Language Archive...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header section
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange.shade800, Colors.orange.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign Language Archive',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Browse through our collection of ${_signVideos.length} sign language videos across multiple categories.',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.white),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Tap on any video to view a detailed demonstration.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    // Greetings Category
                    _buildCategorySection('Greetings'),
                    
                    // Common Phrases Category
                    _buildCategorySection('Common Phrases'),
                    
                    // Responses Category
                    _buildCategorySection('Responses'),
                    
                    // Emotions Category
                    _buildCategorySection('Emotions'),
                    
                    // Basic Needs Category
                    _buildCategorySection('Basic Needs'),
                    
                    // Places Category
                    _buildCategorySection('Places'),
                    
                    // Emergency Category
                    _buildCategorySection('Emergency'),
                    
                    // Relationships Category
                    _buildCategorySection('Relationships'),
                  ],
                ),
              ),
            ),
    );
  }
  
  /// Build a section for a specific category with horizontal scrolling videos
  Widget _buildCategorySection(String category) {
    final categoryVideos = _getVideosByCategory(category);
    if (categoryVideos.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                category,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${categoryVideos.length} videos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryVideos.length,
            itemBuilder: (context, index) {
              final video = categoryVideos[index];
              return _buildVideoCard(video);
            },
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
  
  /// Build an individual video card
  Widget _buildVideoCard(Map<String, dynamic> video) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignVideoDetailPage(videoData: video),
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video thumbnail with play button
              Stack(
                alignment: Alignment.center,
                children: [
                  // Video thumbnail (a placeholder image is used here)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      height: 110,
                      width: double.infinity,
                      color: Colors.orange.shade200,
                      child: Image.asset(
                        video['thumbnail'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  // Animated play button
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 1.0, end: 1.2),
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: child,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.orange.shade700,
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video title
                    Text(
                      video['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Video description
                    Text(
                      video['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Difficulty indicator
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(video['difficulty']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            video['difficulty'],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _getDifficultyColor(video['difficulty']),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Get color based on difficulty level
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green.shade700;
      case 'Medium':
        return Colors.orange.shade700;
      case 'Hard':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
