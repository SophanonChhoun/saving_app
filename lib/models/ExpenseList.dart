import 'dart:convert';

import 'package:saving_app/models/Expense.dart';

ExpenseList expenseListFromMap(String str) =>
    ExpenseList.fromMap(json.decode(str));

String expenseListToMap(ExpenseList data) => json.encode(data.toMap());

class ExpenseList {
  ExpenseList({
    this.expense,
    this.totalAmount,
  });

  List<Expense> expense;
  int totalAmount;

  factory ExpenseList.fromMap(Map<String, dynamic> json) => ExpenseList(
        expense: json["expense"] == null
            ? null
            : List<Expense>.from(
                json["expense"].map((x) => Expense.fromMap(x))),
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
      );

  Map<String, dynamic> toMap() => {
        "expense": expense == null
            ? null
            : List<dynamic>.from(expense.map((x) => x.toMap())),
        "totalAmount": totalAmount == null ? null : totalAmount,
      };
}
