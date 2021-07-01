import 'package:flutter/material.dart';
import 'package:saving_app/repos/UserRepository.dart';
import 'package:saving_app/widgets/flare_sized_circular_progress_indicator.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  @override
  var width;
  var height;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController oldPasswordTextEditingController =
      new TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      new TextEditingController();
  UserRepo _userRepo = new UserRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          iconSize: width / 10,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.yellow[800],
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  _buildForm() {
    final bool obscureText = true;
    final _borderRadius = BorderRadius.all(Radius.circular(8));
    final _oldDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
      border: OutlineInputBorder(borderRadius: _borderRadius),
      hintText: "Old Password",
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    );
    final _newDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
      border: OutlineInputBorder(borderRadius: _borderRadius),
      hintText: "New Password",
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    );
    final _confirmDecoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
      border: OutlineInputBorder(borderRadius: _borderRadius),
      hintText: "Confirm Password",
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    );

    final _passwordField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
      },
      obscureText: obscureText,
      decoration: _newDecoration,
      controller: passwordTextEditingController,
    );

    final _oldPasswordField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your old password";
        }
        return null;
      },
      obscureText: obscureText,
      decoration: _oldDecoration,
      controller: oldPasswordTextEditingController,
    );

    final _confirmPasswordField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        if (value != passwordTextEditingController.text) {
          return "Your new password and confirm password does not match.";
        }
        return null;
      },
      obscureText: obscureText,
      decoration: _confirmDecoration,
      controller: confirmPasswordTextEditingController,
    );

    final _signInButton = ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                if (_formKey.currentState.validate()) {
                  setState(() {
                    _isLoading = true;
                  });
                  _formKey.currentState.save();
                  bool userPasswordUpdated = await _userRepo.updateUserPassword(
                      passwordTextEditingController.text,
                      oldPasswordTextEditingController.text);
                  if (userPasswordUpdated) {
                    final snackBar = SnackBar(
                        content: Text("Your password has been updated."),
                        backgroundColor: Theme.of(context).primaryColor);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _formKey.currentState.reset();
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    final snackBar = SnackBar(
                        content:
                            Text("Sorry, your old password does not correct."),
                        backgroundColor: Theme.of(context).errorColor);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _formKey.currentState.reset();
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
        child: _isLoading
            ? FlareSizedCircularProgressIndicator(size: 16)
            : Text("Save here"));
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Change your password here:",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _oldPasswordField,
            SizedBox(
              height: 16,
            ),
            _passwordField,
            SizedBox(
              height: 16,
            ),
            _confirmPasswordField,
            SizedBox(
              height: 16,
            ),
            SizedBox(height: 24),
            _signInButton,
          ],
        ),
      ),
    );
  }
}
