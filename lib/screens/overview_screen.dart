import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:saving_app/components/card_component.dart';
import 'package:saving_app/models/Expense.dart';
import 'package:saving_app/models/ExpenseList.dart';
import 'package:saving_app/models/Saving.dart';
import 'package:saving_app/models/SavingList.dart';
import 'package:saving_app/repos/ExpenseRepository.dart';
import 'package:saving_app/repos/SavingRepository.dart';
import 'package:saving_app/screens/expense_screen.dart';
import 'package:saving_app/screens/saving_screen.dart';
import 'package:saving_app/screens/setting_screen.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with TickerProviderStateMixin {
  TabController _controller;
  var width;
  var height;
  final _expenseRepo = new ExpenseRepo();
  final _savingRepo = new SavingRepo();
  ExpenseList _expenseList;
  SavingList _savingList;
  Future _dataExpense;
  Future _dataSaving;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMessage(String text) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _dataSaving = _savingRepo.readAllSaving();
    _dataExpense = _expenseRepo.readAllExpense();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar,
      body: _buildBody,
      bottomNavigationBar: _buildButtonNavigationBar,
    );
  }

  get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.yellow[800],
      centerTitle: true,
      title: Text("Transaction Overview"),
      bottom: TabBar(
        controller: _controller,
        tabs: [
          Tab(
            text: ("Expense"),
          ),
          Tab(
            text: ("Saving"),
          )
        ],
      ),
    );
  }

  get _buildBody {
    return TabBarView(
      controller: _controller,
      children: [
        _buildExpenseBody,
        _buildSavingBody,
      ],
    );
  }

  get _buildExpenseBody {
    return RefreshIndicator(
      child: FutureBuilder(
        future: _dataExpense,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("snapshot.error: ${snapshot.error}");
            return Center(
              child: Text(snapshot.error),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _expenseList = snapshot.data;
            return _buildExpense();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      onRefresh: () async {
        setState(() {
          _dataExpense = _expenseRepo.readAllExpense();
        });
      },
    );
  }

  _buildExpense() {
    return ListView(
      children: [
        _buildExpenseCard(),
        _buildExpenseTransactionTitle(),
        _buildExpenseTransaction(),
      ],
    );
  }

  get _buildSavingBody {
    return RefreshIndicator(
      child: FutureBuilder(
        future: _dataSaving,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("snapshot.error: ${snapshot.error}");
            return Center(
              child: Text(snapshot.error),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _savingList = snapshot.data;
            return _buildSaving();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      onRefresh: () async {
        setState(() {
          _dataSaving = _savingRepo.readAllSaving();
        });
      },
    );
  }

  _buildSaving() {
    return ListView(
      children: [
        _buildSavingCard(),
        _buildSavingTransactionTitle(),
        _buildSavingTransaction(),
      ],
    );
  }

  _buildExpenseCard() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: CardComponent(
        colors: Colors.red,
        text: "-${_expenseList.totalAmount ?? 0} \$",
        title: "TOTAL EXPENSE",
      ),
    );
  }

  _buildSavingCard() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: CardComponent(
        colors: Colors.green,
        text: "${_savingList.totalAmount ?? 0} \$",
        title: "TOTAL Saving",
      ),
    );
  }

  _buildExpenseTransactionTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Last Expense Transaction",
            style: TextStyle(
              fontSize: 24,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ExpenseScreen(
                            expense: Expense(),
                          )))
                  .then((value) {
                setState(() {
                  _dataExpense = _expenseRepo.readAllExpense();
                });
              });
            },
            icon: Icon(Icons.add),
            iconSize: 30,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  _buildSavingTransactionTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Last Saving Transaction",
            style: TextStyle(
              fontSize: 24,
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => SavingScreen(
                            saving: Saving(),
                          )))
                  .then((value) {
                setState(() {
                  _dataSaving = _savingRepo.readAllSaving();
                });
              });
            },
            icon: Icon(Icons.add),
            iconSize: 30,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  _buildExpenseTransaction() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: _expenseList.expense.length,
        itemBuilder: (context, index) {
          var expense = _expenseList.expense[index];

          String _day = DateFormat.d().format(expense.date);
          String _month = DateFormat.MMM().format(expense.date);
          return Slidable(
              child: _buildCard("${_day}", "${expense.amount}", "${_month}",
                  "${expense.title}", "${expense.note}", Colors.red),
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                IconSlideAction(
                  caption: 'Edit',
                  color: Colors.yellow,
                  icon: Icons.edit_outlined,
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => ExpenseScreen(
                                  expense: _expenseList.expense[index],
                                )))
                        .then((value) {
                      setState(() {
                        _dataExpense = _expenseRepo.readAllExpense();
                      });
                    });
                  },
                ),
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    var result = await _expenseRepo.deletedExpense(expense.id);
                    if (result) {
                      _showMessage("Deleted successfully.");
                      _dataExpense = _expenseRepo.readAllExpense();
                    } else {
                      _showMessage("Deleted not success.");
                    }
                  },
                ),
              ]);
        },
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  _buildSavingTransaction() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: _savingList.savings.length,
        itemBuilder: (context, index) {
          var saving = _savingList.savings[index];

          String _day = DateFormat.d().format(saving.date);
          String _month = DateFormat.MMM().format(saving.date);
          return Slidable(
            child: _buildCard("${_day}", "${saving.amount}", "${_month}",
                "${saving.title}", "${saving.note}", Colors.green),
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: 'Edit',
                color: Colors.yellow,
                icon: Icons.edit_outlined,
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => SavingScreen(
                                saving: _savingList.savings[index],
                              )))
                      .then((value) {
                    setState(() {
                      _dataSaving = _savingRepo.readAllSaving();
                    });
                  });
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () async {
                  var result = await _savingRepo.deletedSaving(saving.id);
                  if (result) {
                    _showMessage("Deleted successfully.");
                    setState(() {
                      _dataSaving = _savingRepo.readAllSaving();
                    });
                  } else {
                    _showMessage("Deleted not success.");
                  }
                },
              ),
            ],
          );
        },
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
      ),
    );
  }

  _buildCard(date, money, month, title, description, color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: Column(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                month,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          trailing: Text(
            "${money} \$",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[800],
            ),
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description),
                // Text("${item.date}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  get _buildButtonNavigationBar {
    return BottomAppBar(
      color: Colors.yellow[800],
      child: SizedBox(
        height: 58,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(CupertinoIcons.money_dollar_circle),
                iconSize: 35,
                onPressed: () {}),
            IconButton(
                icon: Icon(CupertinoIcons.person),
                color: Colors.white,
                iconSize: 35,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                }),
          ],
        ),
      ),
    );
  }
}
