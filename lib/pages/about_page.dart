import 'package:flutter/material.dart';

/// AboutPage displays information about the Bridging Silence app's mission,
/// target audience, technology, and future vision
/// with support for both English and Swahili languages
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  final ScrollController _scrollController = ScrollController();
  
  // Track which sections are visible for animations
  final Map<String, bool> _visibleSections = {
    'mission': false,
    'who': false,
    'how': false,
    'future': false,
  };
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller for fade effects
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    // Add scroll listener to animate sections as they become visible
    _scrollController.addListener(_checkVisibleSections);
    
    // Initialize all sections to invisible, except first one
    _visibleSections['mission'] = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  
  // Check which sections are visible during scrolling
  void _checkVisibleSections() {
    // This would be implemented with actual visibility detection in a real app
    // For simplicity, we'll use scroll position as a proxy
    final scrollPosition = _scrollController.position.pixels;
    final viewportHeight = _scrollController.position.viewportDimension;
    
    setState(() {
      if (scrollPosition < viewportHeight * 0.25) {
        _visibleSections['mission'] = true;
      }
      
      if (scrollPosition > viewportHeight * 0.1) {
        _visibleSections['who'] = true;
      }
      
      if (scrollPosition > viewportHeight * 0.3) {
        _visibleSections['how'] = true;
      }
      
      if (scrollPosition > viewportHeight * 0.5) {
        _visibleSections['future'] = true;
      }
    });
  }
  
  // Toggle between English and Swahili
  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
      
      // Animate the language change
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEnglish ? 'About Bridging Silence' : 'Kuhusu Bridging Silence',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[700],
        actions: [
          // Language toggle button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
              icon: const Icon(Icons.language, color: Colors.white),
              label: Text(
                _isEnglish ? 'EN' : 'SW',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: _toggleLanguage,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              children: [
                // App logo and name
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/logo.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bridging Silence',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isEnglish ? 'Version 1.0.0' : 'Toleo 1.0.0',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Mission Section
                _buildAnimatedSection(
                  title: _isEnglish ? 'Our Mission' : 'Dhamira Yetu',
                  icon: Icons.track_changes,
                  content: _isEnglish
                      ? 'Bridging Silence is dedicated to breaking down communication barriers between the deaf and hearing communities. Our mission is to create accessible technology that enables seamless communication for everyone, regardless of hearing ability.'
                      : 'Bridging Silence inajitahidi kuvunja vikwazo vya mawasiliano kati ya jamii za viziwi na wanaosikia. Dhamira yetu ni kuunda teknolojia inayopatikana kwa urahisi ambayo inawezesha mawasiliano yasiyo na kikomo kwa kila mtu, bila kujali uwezo wa kusikia.',
                  isVisible: _visibleSections['mission']!,
                ),
                
                const SizedBox(height: 20),
                
                // Who We Help Section
                _buildAnimatedSection(
                  title: _isEnglish ? 'Who We Help' : 'Tunasaidia Nani',
                  icon: Icons.people,
                  content: _isEnglish
                      ? 'Our app serves the deaf and hard-of-hearing community, their families, friends, and colleagues. It is also useful for professionals like teachers, healthcare workers, and customer service representatives who interact with deaf individuals. We aim to make communication inclusive for all.'
                      : 'Programu yetu inasaidia jamii ya viziwi na wasiosikia vizuri, familia zao, marafiki, na wafanyakazi wenzao. Pia ni muhimu kwa wataalamu kama vile walimu, wafanyakazi wa afya, na wawakilishi wa huduma kwa wateja ambao wanawasiliana na watu viziwi. Tunalenga kufanya mawasiliano yajumuishe wote.',
                  isVisible: _visibleSections['who']!,
                ),
                
                const SizedBox(height: 20),
                
                // How It Works Section
                _buildAnimatedSection(
                  title: _isEnglish ? 'How It Works' : 'Jinsi Inavyofanya Kazi',
                  icon: Icons.device_hub,
                  content: _isEnglish
                      ? 'Bridging Silence uses advanced artificial intelligence to recognize hand gestures and translate them into text and speech. Our technology combines computer vision for tracking hand landmarks with neural networks trained on thousands of sign language examples. For speech-to-sign translation, we use speech recognition coupled with animated visual representations of signs.'
                      : 'Bridging Silence inatumia akili bandia ya hali ya juu kutambua ishara za mkono na kuzitafsiri kuwa maandishi na hotuba. Teknolojia yetu inachanganya maono ya kompyuta kwa kufuatilia alama za mkono na mitandao ya neva iliyofunzwa kwa mifano elfu za lugha ya ishara. Kwa tafsiri ya hotuba-kwa-ishara, tunatumia utambuzi wa hotuba pamoja na uwakilishi wa kuona wa ishara.',
                  isVisible: _visibleSections['how']!,
                ),
                
                const SizedBox(height: 20),
                
                // Future Vision Section
                _buildAnimatedSection(
                  title: _isEnglish ? 'Our Future Vision' : 'Maono Yetu ya Baadaye',
                  icon: Icons.visibility,
                  content: _isEnglish
                      ? 'We are continuously expanding our sign language library to include more signs, dialects, and international sign languages. Future updates will bring offline functionality, enhanced accuracy, real-time group conversations, educational features, and integration with smart devices for broader accessibility.'
                      : 'Tunaendelea kupanua maktaba yetu ya lugha ya ishara ili kujumuisha ishara zaidi, lahaja, na lugha za ishara za kimataifa. Masasisho ya baadaye yataleta utendaji kazi bila mtandao, usahihi ulioimarishwa, mazungumzo ya vikundi ya wakati halisi, vipengele vya kielimu, na ushirikiano na vifaa vya kisasa kwa upatikanaji mpana zaidi.',
                  isVisible: _visibleSections['future']!,
                ),
                
                const SizedBox(height: 30),
                
                // Contact and social media section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish ? 'Connect With Us' : 'Ungana Nasi',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSocialButton(Icons.email, 'Email'),
                            _buildSocialButton(Icons.facebook, 'Facebook'),
                            _buildSocialButton(Icons.web, 'Website'),
                            _buildSocialButton(Icons.support_agent, 'Support'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Footer
                Center(
                  child: Text(
                    _isEnglish
                        ? '© 2025 Bridging Silence. All rights reserved.'
                        : '© 2025 Bridging Silence. Haki zote zimehifadhiwa.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  // Build a social media button
  Widget _buildSocialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label ${_isEnglish ? 'link coming soon!' : 'kiungo kinakuja hivi karibuni!'}'),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.blue[800],
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
  
  // Build an animated section that fades and slides in when visible
  Widget _buildAnimatedSection({
    required String title,
    required IconData icon,
    required String content,
    required bool isVisible,
  }) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: isVisible ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 800),
        offset: isVisible ? Offset.zero : const Offset(0, 0.2),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: Colors.blue[800],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
