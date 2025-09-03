import 'package:flutter/material.dart';
import 'how_to_use_page.dart';
import 'settings_page.dart';
import 'about_page.dart';

/// HelpSupportPage provides a navigation interface to various help and support pages
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of help and support options
    final helpOptions = [
      {
        'title': 'How to Use',
        'description': 'Learn how to use the app with our step-by-step guide',
        'icon': Icons.help_outline,
        'page': const HowToUsePage(),
      },
      {
        'title': 'Settings',
        'description': 'Customize your app experience',
        'icon': Icons.settings,
        'page': const SettingsPage(),
      },
      {
        'title': 'About Bridging Silence',
        'description': 'Learn more about our mission and vision',
        'icon': Icons.info_outline,
        'page': const AboutPage(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[700]!,
              Colors.blue[50]!,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'How can we help you?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Select an option below to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Help options list
                Expanded(
                  child: ListView.builder(
                    itemCount: helpOptions.length,
                    itemBuilder: (context, index) {
                      final option = helpOptions[index];
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildOptionCard(
                          context,
                          title: option['title'] as String,
                          description: option['description'] as String,
                          icon: option['icon'] as IconData,
                          page: option['page'] as Widget,
                        ),
                      );
                    },
                  ),
                ),
                
                // Support contact button
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Contact Support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Show contact info
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Contact Support'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: support@bridgingsilence.org'),
                              SizedBox(height: 8),
                              Text('Phone: +1 (123) 456-7890'),
                              SizedBox(height: 8),
                              Text('Hours: Monday-Friday, 9AM-5PM'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Build a card for each help option
  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigate to the selected page with animation
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => page,
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                
                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                
                return SlideTransition(
                  position: offsetAnimation,
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Option icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue[700],
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Option text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.blue[700],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
