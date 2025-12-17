import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:jawara_four/colors/app_colors.dart';
import 'package:jawara_four/data/models/recognition_result_model.dart';
import 'package:jawara_four/services/detection_api_service.dart';
import 'package:jawara_four/widgets/detection_result_card.dart';
import 'package:jawara_four/widgets/detection_stats_card.dart';

class DetectionPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const DetectionPage({super.key, required this.cameras});

  @override
  State<DetectionPage> createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  Timer? _captureTimer;

  bool _isProcessing = false;
  RecognitionResult? _lastResult;
  int _selectedCameraIndex = 0; // 0 = rear, 1 = front

  // Detailed performance metrics
  int _captureTime = 0;
  int _apiCallTime = 0;
  int _totalTime = 0;

  // Stats
  int _frameCount = 0;
  int _successCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App Lifecycle Management
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // App became inactive (minimized or phone locked)
      _stopCapture();
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // App came back to foreground
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    // Select camera based on current index
    final cameraIndex = _selectedCameraIndex < widget.cameras.length
        ? _selectedCameraIndex
        : 0;

    _cameraController = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.high, // High resolution for better quality
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _cameraController!.initialize();
      if (mounted) {
        setState(() {});
        _startCapture();
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _switchCamera() async {
    // Stop current capture
    _stopCapture();
    await _cameraController?.dispose();

    // Toggle camera index
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
    });

    // Reinitialize with new camera
    await _initializeCamera();
  }

  void _startCapture() {
    _captureTimer?.cancel(); // Ensure no duplicates
    // Capture every 500ms - balanced for backend processing time
    _captureTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _captureAndRecognize(),
    );
  }

  void _stopCapture() {
    _captureTimer?.cancel();
    _captureTimer = null;
  }

  Future<void> _captureAndRecognize() async {
    if (_isProcessing || _cameraController == null) return;

    final startTime = DateTime.now();

    setState(() {
      _isProcessing = true;
      _frameCount++;
    });

    try {
      // Measure capture time
      final captureStart = DateTime.now();
      final image = await _cameraController!.takePicture();
      final captureEnd = DateTime.now();
      final captureTime = captureEnd.difference(captureStart).inMilliseconds;

      // Measure API call time (includes network + backend processing)
      final apiStart = DateTime.now();
      final result = await DetectionApiService.recognize(image.path);
      final apiEnd = DateTime.now();
      final apiTime = apiEnd.difference(apiStart).inMilliseconds;

      final totalTime = DateTime.now().difference(startTime).inMilliseconds;

      if (mounted) {
        setState(() {
          _lastResult = result;
          _captureTime = captureTime;
          _apiCallTime = apiTime;
          _totalTime = totalTime;

          if (result.success) _successCount++;
        });
      }
    } catch (e) {
      debugPrint('Recognition error: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCapture();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E88E5),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      body: Column(
        children: [
          // Header dengan style dashboard
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Face Detection',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Real-time Recognition',
                          style: TextStyle(fontSize: 11, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  if (widget.cameras.length > 1)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.flip_camera_android,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: _switchCamera,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Main content dengan rounded top corners
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Camera Preview
                    Center(child: CameraPreview(_cameraController!)),

                    // Gradient overlay untuk better contrast (lighter)
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                          stops: const [0.0, 0.4, 1.0],
                        ),
                      ),
                    ),

                    // Recognition Result Overlay
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 12,
                      child: DetectionResultCard(result: _lastResult),
                    ),

                    // Combined Stats & Performance Metrics (more compact)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: DetectionStatsCard(
                        frameCount: _frameCount,
                        successCount: _successCount,
                        captureTime: _captureTime,
                        apiCallTime: _apiCallTime,
                        totalTime: _totalTime,
                      ),
                    ),

                    // Processing Indicator
                    if (_isProcessing)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
