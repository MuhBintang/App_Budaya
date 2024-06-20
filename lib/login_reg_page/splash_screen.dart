import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uas_budaya/login_reg_page/register_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RegisterScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints:
              BoxConstraints.expand(), // Mengisi seluruh ruang yang tersedia
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: FractionalOffset.topLeft,
            //   end: FractionalOffset.bottomRight,
            //   colors: [
            //     Color(0xffF4B5A4),
            //   ],
            // ),
            color: Color(0xffF4B5A4)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: 
                Image.asset("images/logo.png")
              ),
            ],
          ),
        ),
      ),
    );
  }
}