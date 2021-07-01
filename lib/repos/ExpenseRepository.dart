import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:saving_app/models/Expense.dart';
import 'package:saving_app/models/ExpenseList.dart';
import 'package:saving_app/repos/APIRepository.dart';
import 'package:http/http.dart' as http;

class ExpenseRepo extends ApiRepository {
  Future readAllExpense() async {
    http.Response response =
        await http.get("$baseUrl/expenses", headers: await getTokenHeader());

    if (response.statusCode == 200) {
      String body = response.body;
      return compute(expenseListFromMap, body);
    } else {
      print("Expenses Status: ${response.statusCode}");
      print("Expenses Body: ${response.body}");
      throw Exception("Error while reading data");
    }
  }

  Future readExpense(id) async {
    http.Response response = await http.get("$baseUrl/expenses/$id",
        headers: await getTokenHeader());

    if (response.statusCode == 200) {
      String body = response.body;
      return compute(expenseFromMap, body);
    } else {
      print("Expense Status: ${response.statusCode}");
      print("Expense Body: ${response.body}");
      throw Exception("Error while reading data");
    }
  }

  Future createExpense(title, note, amount, date) async {
    http.Response response = await http.post(
      "$baseUrl/expenses",
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

  Future deletedExpense(id) async {
    http.Response response = await http.delete(
      "$baseUrl/expenses/$id",
      headers: await getTokenHeader(),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future updatedExpense(id, title, note, amount, date) async {
    http.Response response = await http.put(
      "$baseUrl/expenses/$id",
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
