import 'package:flutter/material.dart';
import 'auth/login_page.dart';

/// IntroCarousel widget displays a carousel of pages that explain about the Bridging Silence app
/// Each page contains an image, title, and description
class IntroCarousel extends StatefulWidget {
  const IntroCarousel({super.key});

  @override
  State<IntroCarousel> createState() => _IntroCarouselState();
}

class _IntroCarouselState extends State<IntroCarousel> {
  // Controller for the page view
  final PageController _pageController = PageController();
  
  // Current page index
  int _currentPage = 0;
  
  // List of carousel items containing title, description, and image for each page
  final List<Map<String, dynamic>> _carouselItems = [
    {
      'title': 'Welcome to Bridging Silence',
      'description': 'An innovative platform designed to connect people through meaningful non-verbal communication.',
      'image': 'assets/logo.jpg',
      'color': Colors.blue[900],
    },
    {
      'title': 'Express Without Words',
      'description': 'Discover new ways to express yourself beyond verbal communication. Connect on a deeper level.',
      'image': 'assets/logo.jpg',
      'color': Colors.blue[800],
    },
    {
      'title': 'Build Connections',
      'description': 'Form meaningful connections with others through shared experiences and silent understanding.',
      'image': 'assets/logo.jpg',
      'color': Colors.blue[700],
    },
    {
      'title': 'Join Our Community',
      'description': 'Become part of a growing community dedicated to exploring the power of silence.',
      'image': 'assets/logo.jpg',
      'color': Colors.blue[600],
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Add listener to update the current page when scrolling
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dispose the controller when the widget is removed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background with blue colors
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _carouselItems[_currentPage]['color']!,
              _carouselItems[_currentPage]['color']!.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
                    // Skip button at the top right
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    // Navigate to the login page when Skip is pressed
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),              // Carousel pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _carouselItems.length,
                  itemBuilder: (context, index) {
                    return _buildCarouselPage(
                      title: _carouselItems[index]['title'],
                      description: _carouselItems[index]['description'],
                      imagePath: _carouselItems[index]['image'],
                    );
                  },
                ),
              ),
              
              // Page indicators
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _carouselItems.length,
                    (index) => _buildDotIndicator(index),
                  ),
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button (hidden on first page)
                    _currentPage > 0
                        ? TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : const SizedBox(width: 60),
                    
                    // Next/Finish button
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage < _carouselItems.length - 1) {
                          // Go to next page if not on the last page
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          // Navigate to the login page when Finish is pressed
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _carouselItems[_currentPage]['color'],
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        _currentPage < _carouselItems.length - 1 ? 'Next' : 'Get Started',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  /// Builds an individual carousel page with title, description, and image
  Widget _buildCarouselPage({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            width: 180,
            height: 180,
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a dot indicator for the current page
  Widget _buildDotIndicator(int index) {
    bool isActive = _currentPage == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
