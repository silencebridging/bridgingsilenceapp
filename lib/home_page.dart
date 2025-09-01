import 'package:flutter/material.dart';
import 'service_detail_page.dart';
import 'auth/profile_page.dart';

/// HomePage is the main screen of the app after completing the welcome and intro carousel
/// It displays the main services offered by the Bridging Silence app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    // Return the appropriate page based on the selected tab
    if (_currentIndex == 1) {
      return Scaffold(
        body: const ProfilePage(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    }
    
    // Default to home page content
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bridging Silence',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[800]!,
              Colors.blue[50]!,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header section with logo and welcome message
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome to Bridging Silence',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Connect through meaningful non-verbal communication',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Services Grid
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: const [
                      // Sign to Speech Service
                      ServiceCard(
                        title: 'Sign to Speech',
                        description: 'Convert sign language gestures into spoken words and text',
                        icon: Icons.record_voice_over,
                        backgroundColor: Colors.blue,
                      ),
                      
                      // Speech to Sign Service
                      ServiceCard(
                        title: 'Speech to Sign',
                        description: 'Convert spoken words into sign language visualizations',
                        icon: Icons.mic,
                        backgroundColor: Colors.green,
                      ),
                      
                      // Sign Language Archive
                      ServiceCard(
                        title: 'Sign Language Archive',
                        description: 'Browse our comprehensive library of sign language resources',
                        icon: Icons.video_library,
                        backgroundColor: Colors.orange,
                      ),
                      
                      // How to Use
                      ServiceCard(
                        title: 'How to Use',
                        description: 'Learn how to effectively use Bridging Silence features',
                        icon: Icons.help_outline,
                        backgroundColor: Colors.purple,
                      ),
                      
                      // About Bridging Silence
                      ServiceCard(
                        title: 'About Bridging Silence',
                        description: 'Learn about our mission and the team behind the app',
                        icon: Icons.info_outline,
                        backgroundColor: Colors.teal,
                      ),
                      
                      // Settings
                      ServiceCard(
                        title: 'Settings',
                        description: 'Customize your app experience and preferences',
                        icon: Icons.settings,
                        backgroundColor: Colors.blueGrey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}

/// ServiceCard widget represents a card for a service offered by the app
class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;
  
  const ServiceCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the service detail page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailPage(
                title: title,
                description: description,
                icon: icon,
                color: backgroundColor,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Service icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: backgroundColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: backgroundColor,
                ),
              ),
              const SizedBox(height: 15),
              
              // Service title
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              // Service description
              Text(
                description,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


