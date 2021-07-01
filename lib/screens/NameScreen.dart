import 'package:flutter/material.dart';
import 'package:saving_app/repos/UserRepository.dart';
import 'package:saving_app/widgets/flare_sized_circular_progress_indicator.dart';

class NameScreen extends StatefulWidget {
  final String name;
  final String email;

  const NameScreen({Key key, this.name, this.email}) : super(key: key);

  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  @override
  var width;
  var height;
  String email;
  String password;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = new TextEditingController();
  UserRepo _userRepo = new UserRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextEditingController.text = this.widget.name;
  }

  bool _validateEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

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
    final bool obscureText = false;
    final _borderRadius = BorderRadius.all(Radius.circular(8));
    final _decoration = InputDecoration(
      contentPadding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 4),
      border: OutlineInputBorder(borderRadius: _borderRadius),
      enabledBorder: OutlineInputBorder(
          borderRadius: _borderRadius,
          borderSide: BorderSide(color: Theme.of(context).hintColor)),
    );

    final _emailField = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your name";
        }
        return null;
      },
      obscureText: obscureText,
      decoration: _decoration,
      controller: nameTextEditingController,
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
                  bool userUpdated = await _userRepo.updateUserProfile(
                      this.widget.email, nameTextEditingController.text);
                  if (userUpdated) {
                    final snackBar = SnackBar(
                        content: Text("Your name has been updated."),
                        backgroundColor: Theme.of(context).primaryColor);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    _formKey.currentState.reset();
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    final snackBar = SnackBar(
                        content: Text("Sorry, please try to update again"),
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
                "What should we address you?",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            _emailField,
            SizedBox(height: 24),
            _signInButton,
          ],
        ),
      ),
    );
  }
}
