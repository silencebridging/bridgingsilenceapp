import 'package:flutter/material.dart';

/// HowToUsePage displays a step-by-step guide on how to use the app
/// with support for both English and Swahili languages
class HowToUsePage extends StatefulWidget {
  const HowToUsePage({super.key});

  @override
  State<HowToUsePage> createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // List of steps with icons, titles, and descriptions in both languages
  final List<Map<String, dynamic>> _steps = [
    {
      'icon': Icons.camera_alt,
      'titleEn': 'Step 1: Allow camera access',
      'descriptionEn': 'Give the app permission to use your camera for sign detection.',
      'titleSw': 'Hatua 1: Ruhusu kamera',
      'descriptionSw': 'Peana ruhusa kwa programu kutumia kamera yako kwa utambuzi wa ishara.',
    },
    {
      'icon': Icons.pan_tool,
      'titleEn': 'Step 2: Place your hand in the frame',
      'descriptionEn': 'Position your hand clearly within the camera view.',
      'titleSw': 'Hatua 2: Weka mkono ndani ya fremu',
      'descriptionSw': 'Weka mkono wako vizuri ndani ya mwonekano wa kamera.',
    },
    {
      'icon': Icons.sign_language,
      'titleEn': 'Step 3: Sign clearly',
      'descriptionEn': 'Make sign language gestures slowly and clearly for better recognition.',
      'titleSw': 'Hatua 3: Fanya alama kwa uwazi',
      'descriptionSw': 'Fanya ishara za lugha ya alama polepole na kwa uwazi kwa utambuzi bora.',
    },
    {
      'icon': Icons.translate,
      'titleEn': 'Step 4: See or hear the translation',
      'descriptionEn': 'The app will translate your signs into text and speech.',
      'titleSw': 'Hatua 4: Pata tafsiri kwa maandishi au sauti',
      'descriptionSw': 'Programu itatfsiri ishara zako kuwa maandishi na sauti.',
    },
    {
      'icon': Icons.mic,
      'titleEn': 'Step 5: Use microphone for speech → sign',
      'descriptionEn': 'Speak clearly into the microphone to translate speech to sign language.',
      'titleSw': 'Hatua 5: Tumia kipaza sauti kwa hotuba → ishara',
      'descriptionSw': 'Ongea kwa uwazi kwenye kipaza sauti ili kutafsiri hotuba hadi lugha ya ishara.',
    },
  ];

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          _isEnglish ? 'How to Use' : 'Jinsi ya Kutumia',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Introduction text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      _isEnglish
                          ? 'Follow these steps to effectively use the Bridging Silence app for sign language translation.'
                          : 'Fuata hatua hizi kutumia programu ya Bridging Silence kwa ufanisi kwa tafsiri ya lugha ya ishara.',
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Steps list
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      itemCount: _steps.length,
                      itemBuilder: (context, index) {
                        final step = _steps[index];
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildStepCard(
                            icon: step['icon'],
                            title: _isEnglish ? step['titleEn'] : step['titleSw'],
                            description: _isEnglish ? step['descriptionEn'] : step['descriptionSw'],
                            index: index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Help button
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.help_outline),
                    label: Text(_isEnglish ? 'Get Help' : 'Pata Msaada'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Show help dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEnglish
                              ? 'Help section coming soon!'
                              : 'Sehemu ya msaada inakuja hivi karibuni!'),
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

  // Build a card for each step with animation
  Widget _buildStepCard({
    required IconData icon,
    required String title,
    required String description,
    required int index,
  }) {
    // Stagger the animations
    final delay = Duration(milliseconds: 100 * index);
    
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 500),
            offset: snapshot.connectionState == ConnectionState.done
                ? Offset.zero
                : const Offset(0.5, 0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.blue[700],
                      size: 30,
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey[700],
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
      },
    );
  }
}
