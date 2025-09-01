import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

/// SignToSpeechPage provides the functionality to translate sign language to speech
class SignToSpeechPage extends StatefulWidget {
  const SignToSpeechPage({super.key});

  @override
  State<SignToSpeechPage> createState() => _SignToSpeechPageState();
}

class _SignToSpeechPageState extends State<SignToSpeechPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  String _detectedText = '';
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize the camera
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera(_isFrontCamera ? 1 : 0); // Re-initialize camera
    }
  }

  /// Request camera permission from the user
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _initializeCameras();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission is required to use this feature')),
      );
    }
  }

  /// Initialize available cameras
  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        // Start with front camera (index 1) if available
        final cameraIndex = _cameras!.length > 1 ? 1 : 0;
        _initializeCamera(cameraIndex);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No cameras found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize cameras: $e')),
      );
    }
  }

  /// Initialize the selected camera
  Future<void> _initializeCamera(int cameraIndex) async {
    if (_cameras == null || _cameras!.isEmpty) return;

    // Ensure index is within bounds
    if (cameraIndex >= _cameras!.length) {
      cameraIndex = 0;
    }

    // Update the front/back camera flag
    _isFrontCamera = cameraIndex == 1;

    // Initialize controller for the selected camera
    final controller = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _cameraController = controller;

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize camera: $e')),
        );
      }
    }
  }

  /// Toggle between front and back camera
  void _toggleCamera() {
    if (_cameras == null || _cameras!.length < 2) return;
    
    final newIndex = _isFrontCamera ? 0 : 1;
    _isCameraInitialized = false;
    _cameraController?.dispose();
    _initializeCamera(newIndex);
  }

  /// Simulate sign language detection (would be replaced by actual AI processing)
  void _detectSignLanguage() {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _detectedText = 'Processing...';
    });

    // Simulate processing delay
    Timer(const Duration(seconds: 2), () {
      // This would be replaced with actual sign language processing
      final demoTexts = [
        'Hello, how are you?',
        'Nice to meet you',
        'My name is John',
        'I need help',
        'Thank you',
      ];

      final randomText = demoTexts[DateTime.now().second % demoTexts.length];

      setState(() {
        _isProcessing = false;
        _detectedText = randomText;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign to Speech',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Camera Preview Section (takes most of the screen)
          Expanded(
            flex: 3,
            child: _isCameraInitialized
                ? Stack(
                    children: [
                      // Camera preview
                      SizedBox(
                        width: double.infinity,
                        child: CameraPreview(_cameraController!),
                      ),
                      
                      // Overlay buttons
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Camera flip button
                            FloatingActionButton(
                              heroTag: 'flipCamera',
                              onPressed: _toggleCamera,
                              backgroundColor: Colors.white.withOpacity(0.7),
                              child: const Icon(
                                Icons.flip_camera_ios,
                                color: Colors.black,
                              ),
                            ),
                            
                            // Capture button
                            FloatingActionButton(
                              heroTag: 'captureSign',
                              onPressed: _detectSignLanguage,
                              backgroundColor: Colors.red.withOpacity(0.7),
                              child: _isProcessing
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Icon(
                                      Icons.record_voice_over,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          
          // Text output section (takes smaller portion of the screen)
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.blue.shade50,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detected Text:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        _detectedText.isEmpty ? 'No text detected yet' : _detectedText,
                        style: TextStyle(
                          fontSize: 18,
                          color: _detectedText.isEmpty ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
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
