import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// SpeechToSignPage provides the functionality to translate speech to sign language
class SpeechToSignPage extends StatefulWidget {
  const SpeechToSignPage({super.key});

  @override
  State<SpeechToSignPage> createState() => _SpeechToSignPageState();
}

class _SpeechToSignPageState extends State<SpeechToSignPage> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _spokenText = '';
  String _currentSign = '';
  bool _isSignAnimating = false;

  @override
  void initState() {
    super.initState();
    _initSpeechRecognition();
    _initTextToSpeech();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Initialize speech recognition
  Future<void> _initSpeechRecognition() async {
    final micPermission = await Permission.microphone.request();
    if (micPermission.isGranted) {
      await _speech.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) {
          if (status == 'done') {
            setState(() => _isListening = false);
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission is required for speech recognition')),
      );
    }
  }

  /// Initialize text-to-speech
  Future<void> _initTextToSpeech() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Start listening for speech
  void _startListening() async {
    if (_speech.isAvailable && !_isListening) {
      final bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _spokenText = result.recognizedWords;
              _textController.text = _spokenText;
            });
          },
        );
      }
    }
  }

  /// Stop listening for speech
  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  /// Convert text to sign language (simulated)
  void _convertToSign() {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isSignAnimating = true;
      _currentSign = 'Processing...';
    });

    // Simulate sign language generation delay
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isSignAnimating = false;
        _currentSign = _textController.text;
      });
    });
  }

  /// Speak the entered text aloud
  Future<void> _speakText() async {
    if (_textController.text.isEmpty) return;
    await _flutterTts.speak(_textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Speech to Sign',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Sign language visualization area (video or animation would go here)
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // This is a placeholder for the 3D sign language model
                    // In a real app, this would be a 3D avatar or animation
                    Icon(
                      Icons.sign_language,
                      size: 100,
                      color: _isSignAnimating 
                          ? Colors.green 
                          : Colors.white,
                    ),
                    const SizedBox(height: 20),
                    if (_currentSign.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _isSignAnimating ? 'Generating signs...' : 'Signing: "$_currentSign"',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (_isSignAnimating)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          
          // Text input and control section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.green.shade50,
            child: Column(
              children: [
                // Text input field
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Enter text or speak',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _textController.clear();
                        setState(() {
                          _currentSign = '';
                        });
                      },
                    ),
                  ),
                  maxLines: 2,
                  onChanged: (text) {
                    // Optionally update as user types
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Microphone button for speech input
                    ElevatedButton.icon(
                      onPressed: _isListening ? _stopListening : _startListening,
                      icon: Icon(
                        _isListening ? Icons.mic_off : Icons.mic,
                        color: Colors.white,
                      ),
                      label: Text(
                        _isListening ? 'Stop' : 'Speak',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isListening ? Colors.red : Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    
                    // Convert button
                    ElevatedButton.icon(
                      onPressed: _convertToSign,
                      icon: const Icon(
                        Icons.sign_language,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Convert to Sign',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    
                    // Speak text button
                    IconButton(
                      onPressed: _speakText,
                      icon: const Icon(
                        Icons.volume_up,
                        color: Colors.green,
                        size: 28,
                      ),
                      tooltip: 'Speak text',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
