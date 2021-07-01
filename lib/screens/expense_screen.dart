import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saving_app/models/Expense.dart';
import 'package:saving_app/repos/ExpenseRepository.dart';

class ExpenseScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseScreen({Key key, this.expense}) : super(key: key);

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime _dateTime = DateTime.now();
  var _amountCtr = TextEditingController();
  var _transactionNameCtrl = TextEditingController();
  var _noteCtrl = TextEditingController();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ExpenseRepo _expenseRepo = ExpenseRepo();

  _showMessage(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amountCtr.text =
        widget.expense.amount != null ? widget.expense.amount.toString() : "0";
    _noteCtrl.text = widget.expense.note;
    _transactionNameCtrl.text = widget.expense.title;
    if (widget.expense.date != null) {
      _dateTime = widget.expense.date;
    } else {
      _dateTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar,
      body: InkWell(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: _buildBody,
      ),
    );
  }

  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.red[800],
      centerTitle: false,
      leading: IconButton(
        icon: Icon(CupertinoIcons.back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text("Add Expense Amount"),
    );
  }

  get _buildBody {
    return Container(
      alignment: Alignment.center,
      child: _buildParentView,
    );
  }

  get _buildParentView {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAmountField,
            _buildTransactionField,
            _buildNoteField,
            _buildDateField,
            _buildSaveButton,
          ],
        ),
      ),
    );
  }

  get _buildTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Amount",
        style: TextStyle(fontSize: 24, color: Colors.blue[800]),
      ),
    );
  }

  get _buildAmountField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle,
          _buildAmountInputField,
        ],
      ),
    );
  }

  get _buildAmountInputField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 80,
      child: TextField(
        controller: _amountCtr,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          suffixIcon: Icon(
            CupertinoIcons.money_dollar,
            size: 40,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue[800]),
      ),
    );
  }

  get _buildTransactionNameTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Title",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildTransactionField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTransactionNameTitle,
          _buildTransactionNameField,
        ],
      ),
    );
  }

  get _buildTransactionNameField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 60,
      child: TextField(
        controller: _transactionNameCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue[800], width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
            suffixIcon: Icon(CupertinoIcons.pen)),
        style: TextStyle(fontSize: 18),
        autocorrect: false,
      ),
    );
  }

  get _buildNoteTitle {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      child: Text(
        "Note",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildNoteField {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNoteTitle,
          _buildNoteTextField,
        ],
      ),
    );
  }

  get _buildNoteTextField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      width: 400,
      height: 60,
      child: TextField(
        controller: _noteCtrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: Icon(CupertinoIcons.rectangle_paperclip),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[800], width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        style: TextStyle(fontSize: 18),
        autocorrect: false,
      ),
    );
  }

  get _buildDateTitle {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Text(
        "Date",
        style: TextStyle(fontSize: 18, color: Colors.blue[800]),
      ),
    );
  }

  get _buildDateField {
    return Container(
      margin: EdgeInsets.only(left: 25, top: 10, right: 25, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateTitle,
          _buildDateSelectField,
        ],
      ),
    );
  }

  get _buildDateSelectField {
    String _dateFormatted = DateFormat.yMMMMd().format(_dateTime);
    return InkWell(
      onTap: () {
        _showDateSelectSheet(context);
      },
      child: Container(
        width: 400,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: ListTile(
          leading: Text(
            _dateFormatted,
            style: TextStyle(fontSize: 18),
          ),
          trailing: Icon(CupertinoIcons.calendar),
        ),
      ),
    );
  }

  _showDateSelectSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            height: MediaQuery.of(context).size.height * .25,
            child: CupertinoDatePicker(
              initialDateTime: _dateTime,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (dateTime) {
                setState(() {
                  _dateTime = dateTime;
                });
              },
            ),
          );
        });
  }

  get _buildSaveButton {
    return Container(
      margin: EdgeInsets.all(30),
      height: 50.0,
      width: 200,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(80),
            side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))),
        onPressed: () async {
          if (_amountCtr.text != '' ||
              _transactionNameCtrl.text != '' ||
              _noteCtrl.text != '') {
            if (widget.expense.id != null) {
              var result = await _expenseRepo.updatedExpense(
                  widget.expense.id,
                  _transactionNameCtrl.text,
                  _noteCtrl.text,
                  _amountCtr.text,
                  _dateTime.toString());
              if (result) {
                Navigator.of(context).pop();
              } else {
                _showMessage("Sorry there is something wrong.");
              }
            } else {
              var result = await _expenseRepo.createExpense(
                  _transactionNameCtrl.text,
                  _noteCtrl.text,
                  _amountCtr.text,
                  _dateTime.toString());
              if (result) {
                Navigator.of(context).pop();
              } else {
                _showMessage("Sorry there is something wrong.");
              }
            }
          } else {
            _showMessage("Please input all field");
          }
        },
        padding: EdgeInsets.all(10.0),
        color: Colors.blue[800],
        textColor: Colors.white,
        child: Text("Done", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
