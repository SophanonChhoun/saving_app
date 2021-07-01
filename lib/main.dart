import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saving_app/repos/Auth.dart';
import 'package:saving_app/screens/login_screen.dart';
import 'package:saving_app/screens/overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final primaryColor = Color(0xFF22223B);
  final backgroundColorDarker = Color(0xFFF5F8FF);
  final primaryTextColor = Color(0xFF4A4E69);
  final captionColor = Color(0xFF8e9aaf);
  final primaryBackgroundColor = Color(0xFFFFFFFF);
  // final accentColor = Colors.red;
  final highlightColor = Color(0xFF02C39A);
  final secondaryColor = Color(0xFF8e9aaf);
  final brandColor = Color(0xFF6A00F4);
  final negativeColor = Color(0xFFef233c);

  final AuthRepo authRepo = new AuthRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flare',
      theme: ThemeData(
        primaryColor: primaryColor,
        backgroundColor: primaryBackgroundColor,
        accentColor: brandColor,
        highlightColor: highlightColor,
        hintColor: captionColor,
        errorColor: negativeColor,
        textTheme: TextTheme(
          headline1: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          headline2: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
          headline3: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor)),
        ),
      ),
      home: FutureBuilder(
          future: authRepo.verifyExistingCredentials(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Error loading app");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.data ? OverviewScreen() : LoginScreen();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
