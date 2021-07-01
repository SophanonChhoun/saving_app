import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:saving_app/models/User.dart';
import 'package:saving_app/repos/Auth.dart';
import 'package:saving_app/repos/UserRepository.dart';
import 'package:saving_app/screens/EmailScreen.dart';
import 'package:saving_app/screens/NameScreen.dart';
import 'package:saving_app/screens/PasswordScreen.dart';
import 'package:saving_app/screens/login_screen.dart';
import 'package:saving_app/screens/overview_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Future _data;
  UserRepo _userRepo = new UserRepo();
  User _user;
  AuthRepo authRepo = new AuthRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _data = _userRepo.readUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        centerTitle: true,
        title: Text("Setting"),
      ),
      body: FutureBuilder(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("snapshot.error: ${snapshot.error}");
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            _user = snapshot.data;
            return buildBody();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: _buildButtonNavigationBar,
    );
  }

  buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
      child: ListView(
        children: [
          Text(
            "Settings",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: [
              Icon(
                Icons.person,
                color: Color(0xFF02C39A),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 15,
            thickness: 2,
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NameScreen(
                        name: _user.name,
                        email: _user.email,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Username",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF02C39A)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EmailScreen(
                        name: _user.name,
                        email: _user.email,
                      )));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Email",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF02C39A)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PasswordScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Color(0xFF02C39A)),
                ],
              ),
            ),
          ),
          Divider(
            height: 15,
            thickness: 2,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: OutlineButton(
              padding: EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              onPressed: () {
                authRepo.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
              child: Text("SIGN OUT",
                  style: TextStyle(
                      fontSize: 16, letterSpacing: 2.2, color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildAccountChangeInfo(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF02C39A),
            ),
          ],
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
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushReplacement(PageTransition(
                      child: OverviewScreen(),
                      type: PageTransitionType.rightToLeft));
                }),
            IconButton(
                icon: Icon(CupertinoIcons.person),
                iconSize: 35,
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
