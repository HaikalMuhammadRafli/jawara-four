import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jawara_four/core/detection_config.dart';
import 'package:jawara_four/data/models/recognition_result_model.dart';
import 'package:jawara_four/services/image_processing_service.dart';

class DetectionApiService {
  static final http.Client _client = http.Client();

  /// Check if backend is healthy
  static Future<bool> checkHealth() async {
    try {
      final response = await _client
          .get(Uri.parse('${DetectionConfig.baseUrl}/health'))
          .timeout(Duration(seconds: DetectionConfig.connectTimeout));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check failed: $e');
      return false;
    }
  }

  /// Warm up the backend (for cold start)
  static Future<bool> warmup() async {
    try {
      final response = await _client
          .get(Uri.parse('${DetectionConfig.baseUrl}/warmup'))
          .timeout(Duration(seconds: DetectionConfig.receiveTimeout));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'warm';
      }
      return false;
    } catch (e) {
      debugPrint('Warmup failed: $e');
      return false;
    }
  }

  /// Recognize face from image
  static Future<RecognitionResult> recognize(String imagePath) async {
    try {
      // Process image in background isolate
      // This handles resize + compression without blocking UI
      final compressedBytes = await ImageProcessingService.processImage(
        imagePath,
      );

      if (compressedBytes.isEmpty) {
        return RecognitionResult.error();
      }

      // Send request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${DetectionConfig.baseUrl}/recognize'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          compressedBytes,
          filename: 'frame.jpg',
        ),
      );

      final streamedResponse = await request.send().timeout(
        Duration(seconds: DetectionConfig.receiveTimeout),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return RecognitionResult.fromJson(data);
      }

      return RecognitionResult.error();
    } catch (e) {
      debugPrint('Recognition error: $e');
      return RecognitionResult.error();
    }
  }
}
