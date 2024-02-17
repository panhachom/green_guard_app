import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:green_guard_app/model/prediction_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageUploaderService {
  static Future<List<PredictionModel>> uploadImage(File? imageFile) async {
    final uri = Uri.parse('http://127.0.0.1:5000/predict');
    final request = http.MultipartRequest('POST', uri);
    request.files
        .add(await http.MultipartFile.fromPath('image', imageFile!.path));

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final parsedResponse = json.decode(responseBody);

      List<PredictionModel> diseasePredictions = [];

      // Iterate over the keys in parsedResponse
      parsedResponse.forEach((disease, probability) {
        diseasePredictions.add(
          PredictionModel(disease, probability),
        );
      });

      return diseasePredictions;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return [];
    }
  }
}
