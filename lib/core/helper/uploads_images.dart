import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../network/dio.dart';
import '../network/end_points.dart';
import '../widget/toastification_widget.dart';

class ImagesService {
  static final dioManager = DioManager();

  static Future<String> uploadImage(String path) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        path,
        contentType: DioMediaType("image", "jpeg"),
      ),
    });
    try {
      final Response response = await dioManager.post(
        '${ApiConstants.cachedUrl()}${ApiConstants.upload}',
        data: formData,
      );
      return response.data['image'];
    } on DioException catch (e) {
      log(e.response!.data.toString());
      throw Exception('Failed to upload image');
    }
  }

  static Future<String> uploadImageWeb(XFile image) async {
    try {
      final Uint8List result = await image.readAsBytes();

      final formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          result,
          filename: 'image.jpg',
          contentType: MediaType("image", "jpeg"),
        ),
      });

      // Perform POST request to upload image
      final Response response = await dioManager.post(
        '${ApiConstants.cachedUrl()}${ApiConstants.upload}',
        data: formData,
      );

      return response.data['image'];
    } on DioException catch (e) {
      throw Exception('Failed to upload image : ${e.message}');
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }

  static int maxSizeInBytes = 2 * 1024 * 1024; // [2M]

  static Future<XFile?> pickFile({
    required BuildContext context,
    required ImageSource source,
  }) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    int imageSize = await pickedFile?.length() ?? 1;
    if (!(imageSize <= maxSizeInBytes)) {
      showToastificationWidget(
        context: context,
        message: "يجب الا يتجاوز حجم الصورة 2 ميجا",
      );

      return null;
    }

    if (pickedFile != null) {
      return XFile(pickedFile.path);
    }

    return null;
  }
}
