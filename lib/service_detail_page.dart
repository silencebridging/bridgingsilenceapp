import 'package:flutter/material.dart';
import 'services/sign_to_speech/sign_to_speech_page.dart';
import 'services/speech_to_sign/speech_to_sign_page.dart';
import 'services/sign_language_archive/sign_language_archive_page.dart';
import 'pages/help_support_page.dart';

/// ServiceDetailPage is a generic template for displaying details about a service
class ServiceDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  
  const ServiceDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: color,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color,
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service header section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            size: 40,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Service content section
                  // This would be customized based on the specific service
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'About This Service',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _getServiceDescription(title),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        const Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        
                        // Feature steps
                        ...(_getFeatureSteps(title)).map((step) => FeatureStep(
                          number: step['number'],
                          title: step['title'],
                          description: step['description'],
                        )),
                        
                        const SizedBox(height: 30),
                        
                        // Action button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Launch the specific service functionality based on title
                              if (title == 'Sign to Speech') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignToSpeechPage(),
                                  ),
                                );
                              } else if (title == 'Speech to Sign') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SpeechToSignPage(),
                                  ),
                                );
                              } else if (title == 'Sign Language Archive') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignLanguageArchivePage(),
                                  ),
                                );
                              } else if (title == 'How to Use' || title == 'Settings' || title == 'About Bridging Silence') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HelpSupportPage(),
                                  ),
                                );
                              } else {
                                // For other services, just show a message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('$title service initiated'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              _getButtonText(title),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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
        ),
      ),
    );
  }
  
  /// Returns a more detailed description based on the service title
  String _getServiceDescription(String title) {
    switch (title) {
      case 'Sign to Speech':
        return 'Our Sign to Speech service uses advanced computer vision and AI to recognize sign language gestures and convert them into spoken words and text. This helps bridge the communication gap between those who use sign language and those who don\'t understand it.';
      case 'Speech to Sign':
        return 'Speech to Sign converts spoken language into visual sign language representations. This service helps people learn sign language and enables better communication with the deaf and hard of hearing community.';
      case 'Sign Language Archive':
        return 'Our comprehensive Sign Language Archive contains thousands of signs from different sign languages around the world. It\'s a valuable resource for learning, teaching, and understanding the rich diversity of sign languages.';
      case 'How to Use':
        return 'This section provides detailed guides and tutorials on how to effectively use all features of the Bridging Silence app. Learn tips and tricks to make the most out of our services for better communication.';
      case 'About Bridging Silence':
        return 'Bridging Silence is dedicated to breaking down communication barriers between the deaf and hearing communities. Our mission is to create accessible technology that enables seamless communication for everyone, regardless of hearing ability.';
      default:
        return 'This service is designed to enhance your experience with the Bridging Silence app and help facilitate better communication between sign language users and non-users.';
    }
  }
  
  /// Returns the appropriate button text based on the service title
  String _getButtonText(String title) {
    switch (title) {
      case 'Sign to Speech':
        return 'Start Translating Signs';
      case 'Speech to Sign':
        return 'Start Translating Speech';
      case 'Sign Language Archive':
        return 'Browse Archive';
      case 'How to Use':
        return 'View Tutorials';
      case 'About Bridging Silence':
        return 'Learn More';
      default:
        return 'Get Started';
    }
  }
  
  /// Returns feature steps for the service based on the title
  List<Map<String, dynamic>> _getFeatureSteps(String title) {
    switch (title) {
      case 'Sign to Speech':
        return [
          {
            'number': 1,
            'title': 'Position Your Camera',
            'description': 'Make sure your face and hands are clearly visible in the camera frame.',
          },
          {
            'number': 2,
            'title': 'Perform Sign Language',
            'description': 'Sign naturally as the app captures and analyzes your gestures in real-time.',
          },
          {
            'number': 3,
            'title': 'Review and Share Translation',
            'description': 'The app will speak out and display the text translation, which you can edit or share.',
          },
        ];
      case 'Speech to Sign':
        return [
          {
            'number': 1,
            'title': 'Speak Clearly',
            'description': 'Talk clearly into your device\'s microphone for accurate speech recognition.',
          },
          {
            'number': 2,
            'title': 'View Sign Visualizations',
            'description': 'Watch as the app displays animated sign language gestures for your spoken words.',
          },
          {
            'number': 3,
            'title': 'Practice and Learn',
            'description': 'Follow along with the animations to learn how to sign the phrases you speak.',
          },
        ];
      case 'Sign Language Archive':
        return [
          {
            'number': 1,
            'title': 'Browse Categories',
            'description': 'Explore signs by category, language, or search for specific terms.',
          },
          {
            'number': 2,
            'title': 'View Detailed Demonstrations',
            'description': 'Watch high-quality videos showing how to perform each sign correctly.',
          },
          {
            'number': 3,
            'title': 'Save Favorites',
            'description': 'Create personalized collections of signs for quick access and practice.',
          },
        ];
      default:
        return [
          {
            'number': 1,
            'title': 'Explore Features',
            'description': 'Discover the various services offered by the Bridging Silence app.',
          },
          {
            'number': 2,
            'title': 'Customize Settings',
            'description': 'Adjust settings to suit your preferences and specific needs.',
          },
          {
            'number': 3,
            'title': 'Practice Regularly',
            'description': 'Regular use will help you become more proficient with both the app and sign language.',
          },
        ];
    }
  }
}

/// FeatureStep widget represents a numbered step in the service process
class FeatureStep extends StatelessWidget {
  final int number;
  final String title;
  final String description;
  
  const FeatureStep({
    super.key,
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number circle
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(top: 3, right: 15),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
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
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
