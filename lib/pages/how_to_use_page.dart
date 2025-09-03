import 'package:flutter/material.dart';

/// HowToUsePage displays a comprehensive guide on how to use the app
/// with detailed tutorials, technology explanations, and tips
/// with support for both English and Swahili languages
class HowToUsePage extends StatefulWidget {
  const HowToUsePage({super.key});

  @override
  State<HowToUsePage> createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> with TickerProviderStateMixin {
  bool _isEnglish = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  // List of basic steps with icons, titles, and descriptions in both languages
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

  // Tech explanations in both languages
  final List<Map<String, dynamic>> _techExplanations = [
    {
      'icon': Icons.camera,
      'titleEn': 'Camera and Computer Vision',
      'contentEn': 'Bridging Silence uses your device\'s camera to capture hand movements and gestures. Advanced computer vision algorithms track hand landmarks in real-time, identifying finger positions and hand shapes. This visual data is then processed by our machine learning model to recognize specific signs.',
      'titleSw': 'Kamera na Uoni wa Kompyuta',
      'contentSw': 'Bridging Silence hutumia kamera ya kifaa chako kurekodi harakati na ishara za mikono. Algorithms za hali ya juu za uoni wa kompyuta hufuatilia alama za mkono kwa wakati halisi, kutambua nafasi za vidole na maumbo ya mkono. Data hii ya kuona kisha huchakatwa na modeli yetu ya kujifunza mashine ili kutambua ishara mahususi.',
    },
    {
      'icon': Icons.model_training,
      'titleEn': 'Machine Learning Models',
      'contentEn': 'Our app uses a neural network model trained on thousands of sign language examples. This model can recognize over 1,000 common signs with high accuracy. The AI continuously improves through user feedback, becoming more accurate over time.',
      'titleSw': 'Modeli za Kujifunza Mashine',
      'contentSw': 'Programu yetu hutumia modeli ya mtandao wa neva iliyofunzwa kwa mifano elfu za lugha ya ishara. Modeli hii inaweza kutambua ishara zaidi ya 1,000 za kawaida kwa usahihi wa hali ya juu. AI huendelea kuboresha kupitia maoni ya watumiaji, kuwa sahihi zaidi kwa muda.',
    },
    {
      'icon': Icons.record_voice_over,
      'titleEn': 'Speech Recognition & Text-to-Speech',
      'contentEn': 'For Speech-to-Sign translation, we use high-quality speech recognition that works in noisy environments. This converts spoken words into text, which is then mapped to corresponding sign language animations. The Text-to-Speech feature uses natural-sounding voices to convert sign language back into spoken words.',
      'titleSw': 'Utambuzi wa Hotuba na Maandishi-kwa-Hotuba',
      'contentSw': 'Kwa tafsiri ya Hotuba-kwa-Ishara, tunatumia utambuzi wa hotuba wa hali ya juu unaofanya kazi katika mazingira yenye kelele. Hii hubadilisha maneno yanayozungumzwa kuwa maandishi, ambayo kisha huwekwa kwenye uhuishaji wa lugha ya ishara inayolingana. Kipengele cha Maandishi-kwa-Hotuba hutumia sauti zinazosikika asili kubadilisha lugha ya ishara kuwa maneno yanayozungumzwa.',
    },
    {
      'icon': Icons.photo_library,
      'titleEn': 'Video Analysis & Processing',
      'contentEn': 'Our Sign Language Archive uses advanced video compression and streaming technologies to provide smooth playback even on slower connections. Each video is tagged with metadata for easy searching and categorization.',
      'titleSw': 'Uchambuzi na Usindikaji wa Video',
      'contentSw': 'Jalada letu la Lugha ya Ishara hutumia teknolojia za kisasa za ufinyu wa video na streaming kutoa uchezaji laini hata kwenye miunganisho ya polepole. Kila video imewekwa lebo na metadata kwa utafutaji na uainishaji rahisi.',
    },
    {
      'icon': Icons.storage,
      'titleEn': 'Offline Capability',
      'contentEn': 'The app can function without an internet connection once the initial models are downloaded. This makes it useful in areas with limited connectivity.',
      'titleSw': 'Uwezo wa Nje ya Mtandao',
      'contentSw': 'Programu inaweza kufanya kazi bila muunganisho wa intaneti mara tu modeli za awali zimepakuliwa. Hii huifanya iwe muhimu katika maeneo yenye muunganisho mdogo.',
    },
  ];
  
  // Advanced tips in both languages
  final List<Map<String, dynamic>> _advancedTips = [
    {
      'titleEn': 'Optimize Lighting Conditions',
      'contentEn': 'For best sign recognition, use the app in well-lit environments. Avoid strong backlighting that can create shadows on your hands. Natural light works best, but consistent indoor lighting is also effective.',
      'titleSw': 'Kuboresha Hali za Mwangaza',
      'contentSw': 'Kwa utambuzi bora wa ishara, tumia programu katika mazingira yenye mwangaza mzuri. Epuka mwangaza mkali wa nyuma ambao unaweza kuunda vivuli kwenye mikono yako. Mwangaza wa asili unafanya kazi vizuri zaidi, lakini mwangaza wa ndani unaofanana pia ni wenye ufanisi.',
    },
    {
      'titleEn': 'Positioning Your Camera',
      'contentEn': 'Position your device so your upper body is visible. Keep about 1-2 feet between you and the camera. This gives the app enough visual context to accurately interpret your signs.',
      'titleSw': 'Kuweka Kamera Yako',
      'contentSw': 'Weka kifaa chako ili mwili wako wa juu uonekane. Weka takriban futi 1-2 kati yako na kamera. Hii hutoa programu muktadha wa kutosha wa kuona ili kutafsiri ishara zako kwa usahihi.',
    },
    {
      'titleEn': 'Speaking Clearly',
      'contentEn': 'When using Speech-to-Sign, speak at a moderate pace and articulate clearly. The app works best with natural speech rather than exaggerated pronunciation.',
      'titleSw': 'Kuongea Wazi',
      'contentSw': 'Wakati wa kutumia Hotuba-kwa-Ishara, ongea kwa kasi ya wastani na utamke wazi. Programu inafanya kazi vizuri zaidi na hotuba ya asili badala ya matamshi ya kupindukia.',
    },
    {
      'titleEn': 'Custom Vocabulary',
      'contentEn': 'Add frequently used specialized terms to your custom vocabulary in Settings. This improves recognition for terminology specific to your work or interests.',
      'titleSw': 'Msamiati wa Desturi',
      'contentSw': 'Ongeza maneno maalum yanayotumika mara kwa mara kwenye msamiati wako wa desturi katika Mipangilio. Hii inaboresha utambuzi wa istilahi maalum kwa kazi yako au maslahi.',
    },
    {
      'titleEn': 'Practice Mode',
      'contentEn': 'Use Practice Mode to improve your signing skills. The app provides feedback on your hand positioning and movement to help you learn correct signing technique.',
      'titleSw': 'Hali ya Mazoezi',
      'contentSw': 'Tumia Hali ya Mazoezi kuboresha ujuzi wako wa kuashiria. Programu hutoa maoni juu ya kuweka mkono wako na mwendo ili kukusaidia kujifunza mbinu sahihi ya kuashiria.',
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
    
    // Initialize tab controller for the tutorial tabs
    _tabController = TabController(length: 3, vsync: this);
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: _isEnglish ? 'Getting Started' : 'Kuanza'),
            Tab(text: _isEnglish ? 'Technology' : 'Teknolojia'),
            Tab(text: _isEnglish ? 'Advanced Tips' : 'Vidokezo vya Hali ya juu'),
          ],
        ),
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
          child: TabBarView(
            controller: _tabController,
            children: [
              // FIRST TAB - Getting Started
              SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Introduction card with animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildIntroCard(),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Animated heading
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(20 * (1 - value), 0),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _isEnglish ? 'Step-by-Step Guide' : 'Mwongozo wa Hatua kwa Hatua',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Steps list with staggered animations
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                    
                    const SizedBox(height: 20),
                    
                    // Interactive demo button
                    Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_outline),
                          label: Text(_isEnglish ? 'Interactive Tutorial' : 'Mafunzo ya Ushirikiano'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            // Launch interactive tutorial
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(_isEnglish
                                    ? 'Interactive tutorial coming soon!'
                                    : 'Mafunzo ya ushirikiano yanakuja hivi karibuni!'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              
              // SECOND TAB - Technology Explanation
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tech intro card
                    _buildTechIntroCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Tech components with animations
                    ...List.generate(_techExplanations.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: _buildTechCard(
                          _techExplanations[index]['icon'] as IconData,
                          _isEnglish ? _techExplanations[index]['titleEn'] as String : _techExplanations[index]['titleSw'] as String,
                          _isEnglish ? _techExplanations[index]['contentEn'] as String : _techExplanations[index]['contentSw'] as String,
                          index,
                        ),
                      );
                    }),
                    
                    const SizedBox(height: 20),
                    
                    // Tech demo video section
                    _buildVideoSection(),
                  ],
                ),
              ),
              
              // THIRD TAB - Advanced Tips
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tips intro
                    _buildTipsIntroCard(),
                    
                    const SizedBox(height: 24),
                    
                    // Tips with animations
                    ...List.generate(_advancedTips.length, (index) {
                      return _buildTipCard(
                        _isEnglish ? _advancedTips[index]['titleEn'] as String : _advancedTips[index]['titleSw'] as String,
                        _isEnglish ? _advancedTips[index]['contentEn'] as String : _advancedTips[index]['contentSw'] as String,
                        index,
                      );
                    }),
                    
                    const SizedBox(height: 30),
                    
                    // Help button
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.contact_support),
                        label: Text(_isEnglish ? 'Contact Support' : 'Wasiliana na Msaada'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // Show contact info dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(_isEnglish ? 'Contact Support' : 'Wasiliana na Msaada'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_isEnglish ? 'Email: support@bridgingsilence.org' : 'Barua pepe: support@bridgingsilence.org'),
                                  const SizedBox(height: 8),
                                  Text(_isEnglish ? 'Phone: +1 (123) 456-7890' : 'Simu: +1 (123) 456-7890'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text(_isEnglish ? 'Close' : 'Funga'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Introduction card with animation
  Widget _buildIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[600]!, Colors.blue[800]!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars,
                color: Colors.amber[300],
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isEnglish ? 'Welcome to Bridging Silence' : 'Karibu kwenye Bridging Silence',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _isEnglish
                ? 'This guide will help you learn how to use all features of Bridging Silence effectively. Follow along to discover how to translate between sign language and speech with ease.'
                : 'Mwongozo huu utakusaidia kujifunza jinsi ya kutumia vipengele vyote vya Bridging Silence kwa ufanisi. Fuata ili kugundua jinsi ya kutafsiri kati ya lugha ya ishara na hotuba kwa urahisi.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Technology introduction card
  Widget _buildTechIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple[400]!, Colors.purple[700]!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.computer,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isEnglish ? 'Technology Behind Bridging Silence' : 'Teknolojia Nyuma ya Bridging Silence',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _isEnglish
                ? 'Discover the advanced technology that powers our sign language translation. Understanding how these technologies work will help you get the most out of the app.'
                : 'Gundua teknolojia ya kisasa inayoendesha tafsiri yetu ya lugha ya ishara. Kuelewa jinsi teknolojia hizi zinavyofanya kazi kutakusaidia kupata manufaa zaidi kutoka kwa programu.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Advanced tips introduction card
  Widget _buildTipsIntroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal[400]!, Colors.teal[700]!],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb,
                color: Colors.amber,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isEnglish ? 'Advanced Tips & Tricks' : 'Vidokezo na Mbinu za Hali ya Juu',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            _isEnglish
                ? 'These expert tips will help you achieve the best translation results. Learn how to optimize your environment and technique for maximum accuracy.'
                : 'Vidokezo hivi vya wataalamu vitakusaidia kupata matokeo bora ya tafsiri. Jifunze jinsi ya kuboresha mazingira yako na mbinu kwa usahihi wa juu zaidi.',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
  
  // Technology demo video section
  Widget _buildVideoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.smart_display,
            size: 60,
            color: Colors.purple,
          ),
          const SizedBox(height: 15),
          Text(
            _isEnglish ? 'Video Demonstrations' : 'Maonyesho ya Video',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _isEnglish 
                ? 'Watch our in-depth technology demonstrations to better understand how Bridging Silence works.' 
                : 'Tazama maonyesho yetu ya kina ya teknolojia ili kuelewa vizuri jinsi Bridging Silence inavyofanya kazi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: Text(_isEnglish ? 'Watch Demo Videos' : 'Tazama Video za Maonyesho'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[700],
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              // Open demo videos
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isEnglish
                      ? 'Demo videos coming soon!'
                      : 'Video za maonyesho zinakuja hivi karibuni!'),
                ),
              );
            },
          ),
        ],
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
                  // Step number and icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          icon,
                          color: Colors.blue[700],
                          size: 30,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
  
  // Build a card for each technology component with animation
  Widget _buildTechCard(IconData icon, String title, String content, int index) {
    // Stagger the animations
    final delay = Duration(milliseconds: 150 * index);
    
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            offset: snapshot.connectionState == ConnectionState.done
                ? Offset.zero
                : const Offset(0, 0.2),
            child: Container(
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tech icon with animated background
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple.shade300, Colors.purple.shade700],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Content
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey[700],
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
  
  // Build a card for each tip with animation
  Widget _buildTipCard(String title, String content, int index) {
    // Stagger the animations
    final delay = Duration(milliseconds: 150 * index);
    
    return FutureBuilder(
      future: Future.delayed(delay),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: snapshot.connectionState == ConnectionState.done ? 1.0 : 0.0,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.teal.withOpacity(0.3), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tip title with icon
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb,
                      color: Colors.amber[700],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                // Tip content
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
