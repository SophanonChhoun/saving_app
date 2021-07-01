import 'dart:convert';

Expense expenseFromMap(String str) => Expense.fromMap(json.decode(str));

String expenseToMap(Expense data) => json.encode(data.toMap());

class Expense {
  Expense({
    this.amount,
    this.id,
    this.title,
    this.user,
    this.note,
    this.date,
    this.v,
  });

  int amount;
  String id;
  String title;
  String user;
  String note;
  DateTime date;
  int v;

  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
        amount: json["amount"] == null ? null : json["amount"],
        id: json["_id"] == null ? null : json["_id"],
        title: json["title"] == null ? null : json["title"],
        user: json["user"] == null ? null : json["user"],
        note: json["note"] == null ? null : json["note"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        v: json["__v"] == null ? null : json["__v"],
      );

  Map<String, dynamic> toMap() => {
        "amount": amount == null ? null : amount,
        "_id": id == null ? null : id,
        "title": title == null ? null : title,
        "user": user == null ? null : user,
        "note": note == null ? null : note,
        "date": date == null ? null : date.toIso8601String(),
        "__v": v == null ? null : v,
      };
}
