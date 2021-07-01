import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_app/models/Saving.dart';
import 'package:saving_app/models/SavingList.dart';
import 'package:saving_app/repos/APIRepository.dart';
import 'package:http/http.dart' as http;

class SavingRepo extends ApiRepository {
  Future readAllSaving() async {
    http.Response response =
        await http.get("$baseUrl/savings", headers: await getTokenHeader());
    if (response.statusCode == 200) {
      String body = response.body;
      return compute(savingListFromMap, body);
    } else {
      print("Savings Status: ${response.statusCode}");
      print("Savings Body: ${response.body}");
      throw Exception("Error while reading data");
    }
  }

  Future readSaving(id) async {
    http.Response response =
        await http.get("$baseUrl/savings/$id", headers: await getTokenHeader());

    if (response.statusCode == 200) {
      String body = response.body;
      return compute(savingFromMap, body);
    } else {
      print("Saving Status: ${response.statusCode}");
      print("Saving Body: ${response.body}");
      throw Exception("Error while reading data");
    }
  }

  Future createSavings(title, note, amount, date) async {
    http.Response response = await http.post(
      "$baseUrl/savings",
      headers: await getTokenHeader(),
      body: jsonEncode({
        "title": title,
        "note": note,
        "amount": amount,
        "date": date,
      }),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deletedSaving(id) async {
    http.Response response = await http.delete(
      "$baseUrl/savings/$id",
      headers: await getTokenHeader(),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updatedSaving(id, title, note, amount, date) async {
    http.Response response = await http.put(
      "$baseUrl/savings/$id",
      headers: await getTokenHeader(),
      body: jsonEncode({
        "title": title,
        "note": note,
        "amount": amount,
        "date": date,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
