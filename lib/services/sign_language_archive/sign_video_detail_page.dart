import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

/// SignVideoDetailPage displays a detailed view of a sign language video
/// with playback controls and additional information
class SignVideoDetailPage extends StatefulWidget {
  final Map<String, dynamic> videoData;
  
  const SignVideoDetailPage({
    super.key,
    required this.videoData,
  });

  @override
  State<SignVideoDetailPage> createState() => _SignVideoDetailPageState();
}

class _SignVideoDetailPageState extends State<SignVideoDetailPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }
  
  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
  
  /// Initialize the video player with the video path from widget.videoData
  Future<void> _initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(widget.videoData['videoPath']);
      
      await _videoPlayerController!.initialize();
      
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.orange,
          handleColor: Colors.orangeAccent,
          backgroundColor: Colors.grey.shade300,
          bufferedColor: Colors.orange.shade100,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        ),
        autoInitialize: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          );
        },
      );
      
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load video: $e';
      });
      print('Error initializing video player: $e');
    }
  }

  /// Retry loading the video if it failed
  void _retryVideoLoading() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    
    _initializeVideoPlayer();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.videoData['title'],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: [
          // Share button
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing functionality coming soon!')),
              );
            },
          ),
          // Bookmark button
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark functionality coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video player
            Container(
              color: Colors.black,
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 9 / 16,
              child: _hasError
                  ? _buildErrorWidget()
                  : !_isInitialized
                      ? _buildLoadingWidget()
                      : Chewie(controller: _chewieController!),
            ),
            
            // Video information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and difficulty
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.videoData['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(widget.videoData['difficulty']).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.videoData['difficulty'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(widget.videoData['difficulty']),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Category chip
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        label: Text(
                          widget.videoData['category'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.orange.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.videoData['description'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // How to perform section
                  const Text(
                    'How to Perform',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Steps to perform the sign
                  _buildStepCard(
                    1,
                    'Position',
                    'Start with your hands in a neutral position in front of your body.',
                  ),
                  _buildStepCard(
                    2,
                    'Movement', 
                    'Follow the movement shown in the video carefully, paying attention to hand shape and orientation.',
                  ),
                  _buildStepCard(
                    3,
                    'Expression',
                    'Facial expressions are an important part of sign language. Match your expression to the meaning of the sign.',
                  ),
                  _buildStepCard(
                    4,
                    'Practice',
                    'Repeat the sign several times to commit it to muscle memory.',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Practice button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (_isInitialized && _videoPlayerController != null) {
                          _videoPlayerController!.seekTo(Duration.zero);
                          _videoPlayerController!.play();
                        }
                      },
                      icon: const Icon(Icons.replay),
                      label: const Text('Practice Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Divider
                  Divider(color: Colors.grey.shade300, thickness: 1),
                  
                  const SizedBox(height: 16),
                  
                  // Related videos section (placeholder)
                  const Text(
                    'Related Signs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Coming soon - related signs and phrases will be available here.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isInitialized && _videoPlayerController != null) {
            if (_videoPlayerController!.value.isPlaying) {
              _videoPlayerController!.pause();
            } else {
              _videoPlayerController!.play();
            }
            setState(() {});
          }
        },
        backgroundColor: Colors.orange,
        child: Icon(
          _isInitialized && _videoPlayerController!.value.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
        ),
      ),
    );
  }
  
  /// Build a widget to show when the video is loading
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
          SizedBox(height: 16),
          Text(
            'Loading video...',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
  
  /// Build a widget to show when there's an error loading the video
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryVideoLoading,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  /// Build a step card for the "How to Perform" section
  Widget _buildStepCard(int stepNumber, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Step content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
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
