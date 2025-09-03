import 'package:flutter/material.dart';

/// SettingsPage allows users to customize app preferences
/// with support for both English and Swahili languages
/// and detailed explanations of settings options
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with TickerProviderStateMixin {
  bool _isEnglish = true;
  
  // Settings options
  bool _captionsEnabled = true;
  bool _showLandmarks = true;
  bool _vibrationEnabled = true;
  bool _highContrastMode = false;
  String _voiceType = 'Female';
  double _voiceSpeed = 0.5;
  double _voiceVolume = 0.7;
  bool _notificationsEnabled = true;
  bool _dataCollectionEnabled = false;
  bool _autoSignDetection = true;
  String _preferredCamera = 'Front';
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  // Settings descriptions for help popups
  final Map<String, Map<String, String>> _settingsDescriptions = {
    'captions': {
      'titleEn': 'Captions',
      'descriptionEn': 'Shows text captions for all spoken and signed content. Turn this on to see written text alongside translations.',
      'titleSw': 'Manukuu',
      'descriptionSw': 'Huonyesha manukuu ya maandishi kwa maudhui yote yanayozungumzwa na kuashiriwa. Washa ili uone maandishi pamoja na tafsiri.',
    },
    'landmarks': {
      'titleEn': 'Show Hand Landmarks',
      'descriptionEn': 'Displays tracking points on your hands during signing. Useful for verifying that your signs are being detected correctly.',
      'titleSw': 'Onyesha Alama za Mkono',
      'descriptionSw': 'Huonyesha pointi za ufuatiliaji kwenye mikono yako wakati wa kuashiria. Husaidia kuthibitisha kuwa ishara zako zinagundulika kwa usahihi.',
    },
    'vibration': {
      'titleEn': 'Vibration Feedback',
      'descriptionEn': 'Provides tactile feedback when signs are detected or when translations are complete.',
      'titleSw': 'Mrejesho wa Mtetemo',
      'descriptionSw': 'Hutoa mrejesho wa mguso wakati ishara zinagundulika au tafsiri zinakamilika.',
    },
    'highContrast': {
      'titleEn': 'High Contrast Mode',
      'descriptionEn': 'Enhances visual distinction between UI elements for better visibility in various lighting conditions and for users with visual impairments.',
      'titleSw': 'Hali ya Tofauti ya Juu',
      'descriptionSw': 'Huongeza tofauti ya kuona kati ya vipengele vya UI kwa mwonekano bora katika hali mbalimbali za mwangaza na kwa watumiaji wenye ulemavu wa kuona.',
    },
  };
  
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
          _isEnglish ? 'Settings' : 'Mipangilio',
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
              padding: const EdgeInsets.all(16.0),
              children: [
                // Language Section
                _buildSettingSection(
                  icon: Icons.language,
                  title: _isEnglish ? 'Language' : 'Lugha',
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isEnglish ? 'App Language' : 'Lugha ya Programu',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SegmentedButton<bool>(
                            selected: {_isEnglish},
                            segments: [
                              ButtonSegment<bool>(
                                value: true,
                                label: const Text('English'),
                              ),
                              ButtonSegment<bool>(
                                value: false,
                                label: const Text('Swahili'),
                              ),
                            ],
                            onSelectionChanged: (Set<bool> newSelection) {
                              setState(() {
                                _isEnglish = newSelection.first;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Voice Settings Section
                _buildSettingSection(
                  icon: Icons.record_voice_over,
                  title: _isEnglish ? 'Voice Settings' : 'Mipangilio ya Sauti',
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
                          // Voice Type
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _isEnglish ? 'Voice Type' : 'Aina ya Sauti',
                                style: const TextStyle(fontSize: 16),
                              ),
                              DropdownButton<String>(
                                value: _voiceType,
                                items: ['Male', 'Female'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(_isEnglish
                                        ? value
                                        : (value == 'Male' ? 'Mwanaume' : 'Mwanamke')),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _voiceType = newValue;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Voice Speed
                          Text(
                            _isEnglish ? 'Voice Speed' : 'Kasi ya Sauti',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Slider(
                            value: _voiceSpeed,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: _isEnglish
                                ? '${(_voiceSpeed * 100).round()}%'
                                : '${(_voiceSpeed * 100).round()}%',
                            onChanged: (double value) {
                              setState(() {
                                _voiceSpeed = value;
                              });
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Voice Volume
                          Text(
                            _isEnglish ? 'Volume' : 'Sauti',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Slider(
                            value: _voiceVolume,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: _isEnglish
                                ? '${(_voiceVolume * 100).round()}%'
                                : '${(_voiceVolume * 100).round()}%',
                            onChanged: (double value) {
                              setState(() {
                                _voiceVolume = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Display Settings Section
                _buildSettingSection(
                  icon: Icons.display_settings,
                  title: _isEnglish ? 'Display Settings' : 'Mipangilio ya Onyesho',
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Captions
                          _buildSwitchSetting(
                            title: _isEnglish ? 'Show Captions' : 'Onyesha Manukuu',
                            value: _captionsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _captionsEnabled = value;
                              });
                            },
                          ),
                          
                          const Divider(),
                          
                          // Landmarks
                          _buildSwitchSetting(
                            title: _isEnglish ? 'Show Hand Landmarks' : 'Onyesha Alama za Mkono',
                            value: _showLandmarks,
                            onChanged: (value) {
                              setState(() {
                                _showLandmarks = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Accessibility Settings Section
                _buildSettingSection(
                  icon: Icons.accessibility_new,
                  title: _isEnglish ? 'Accessibility' : 'Upatikanaji',
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Vibration
                          _buildSwitchSetting(
                            title: _isEnglish ? 'Vibration Feedback' : 'Mrejesho wa Mtetemo',
                            value: _vibrationEnabled,
                            onChanged: (value) {
                              setState(() {
                                _vibrationEnabled = value;
                              });
                            },
                          ),
                          
                          const Divider(),
                          
                          // High Contrast Mode
                          _buildSwitchSetting(
                            title: _isEnglish ? 'High Contrast Mode' : 'Hali ya Tofauti ya Juu',
                            value: _highContrastMode,
                            onChanged: (value) {
                              setState(() {
                                _highContrastMode = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Privacy Settings Section
                _buildSettingSection(
                  icon: Icons.privacy_tip,
                  title: _isEnglish ? 'Privacy' : 'Faragha',
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
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete_outline),
                            label: Text(
                              _isEnglish ? 'Clear Saved Translations' : 'Futa Tafsiri Zilizohifadhiwa',
                              style: const TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            ),
                            onPressed: () {
                              // Show confirmation dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(_isEnglish ? 'Clear Data?' : 'Futa Data?'),
                                  content: Text(_isEnglish
                                      ? 'This will delete all saved translations. This action cannot be undone.'
                                      : 'Hii itafuta tafsiri zote zilizohifadhiwa. Hatua hii haiwezi kutendwa.'),
                                  actions: [
                                    TextButton(
                                      child: Text(_isEnglish ? 'Cancel' : 'Ghairi'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: Text(_isEnglish ? 'Clear' : 'Futa'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(_isEnglish
                                                ? 'Translations cleared'
                                                : 'Tafsiri zimefutwa'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Save button
                Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: Text(_isEnglish ? 'Save Settings' : 'Hifadhi Mipangilio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // Save settings functionality would go here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEnglish
                              ? 'Settings saved successfully!'
                              : 'Mipangilio imehifadhiwa kikamilifu!'),
                          backgroundColor: Colors.green,
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
  
  // Build a section with an icon, title and content
  Widget _buildSettingSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.blue[800],
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
  
  // Build a switch setting with title and value
  Widget _buildSwitchSetting({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue[700],
        ),
      ],
    );
  }
}
