import 'dart:convert';

import 'package:saving_app/models/Saving.dart';

SavingList savingListFromMap(String str) =>
    SavingList.fromMap(json.decode(str));

String savingListToMap(SavingList data) => json.encode(data.toMap());

class SavingList {
  SavingList({
    this.savings,
    this.totalAmount,
  });

  List<Saving> savings;
  int totalAmount;

  factory SavingList.fromMap(Map<String, dynamic> json) => SavingList(
        savings: json["savings"] == null
            ? null
            : List<Saving>.from(json["savings"].map((x) => Saving.fromMap(x))),
        totalAmount: json["totalAmount"] == null ? null : json["totalAmount"],
      );

  Map<String, dynamic> toMap() => {
        "savings": savings == null
            ? null
            : List<dynamic>.from(savings.map((x) => x.toMap())),
        "totalAmount": totalAmount == null ? null : totalAmount,
      };
}
