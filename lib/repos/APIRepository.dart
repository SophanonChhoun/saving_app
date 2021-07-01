import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class ApiRepository {
  final storage = new FlutterSecureStorage();
  final baseUrl = "http://localhost:5000/api";

  Future<Map<String, String>> getTokenHeader() async {
    String token = await _getLocalToken();
    return {
      'Authorization': "$token",
      HttpHeaders.contentTypeHeader: 'application/json',
    };
  }

  Future<String> _getLocalToken() async {
    return await storage.read(key: "token");
  }
}
