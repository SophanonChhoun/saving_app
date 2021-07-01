import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:saving_app/models/User.dart';

import 'APIRepository.dart';

class UserRepo extends ApiRepository {
  Future readUsers() async {
    http.Response response = await http.get("$baseUrl/users/profile",
        headers: await getTokenHeader());

    if (response.statusCode == 200) {
      String body = response.body;
      return compute(userFromMap, body);
    } else {
      print("User Status: ${response.statusCode}");
      print("User Body: ${response.body}");
      throw Exception("Error while reading data");
    }
  }

  Future updateUserProfile(email, name) async {
    http.Response response = await http.put(
      "$baseUrl/users/profile",
      headers: await getTokenHeader(),
      body: jsonEncode({"email": email, "name": name}),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updateUserPassword(password, oldPassword) async {
    http.Response response = await http.patch(
      "$baseUrl/users/profile",
      headers: await getTokenHeader(),
      body: jsonEncode({"password": password, "old_password": oldPassword}),
    );
    print("status code: ${response.statusCode}");
    print("Body: ${response.body}");
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
