import 'package:connect_z/common/custom_button.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:flutter/material.dart';
import 'auth_pages/login_page.dart';
import 'auth_pages/signup_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ConnectZ_White.png",
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Text(
                  'Welcome, Let\'s \nExplore The World!',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: appinverse),
                ),
              ),
              StdButton(
                  btnText: 'Log In',
                  onBtnPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }));
                  }),
              StdButton(
                  btnText: 'Sign Up',
                  onBtnPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignupPage();
                    }));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
