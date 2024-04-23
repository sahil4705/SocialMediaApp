// ignore_for_file: use_build_context_synchronously

import 'package:connect_z/common/textbox.dart';
import 'package:connect_z/common/custom_button.dart';
import 'package:connect_z/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/constants.dart';
import '../../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confimPassword = TextEditingController();

  GlobalKey formkeySignup = GlobalKey<FormState>();

  var _working = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formkeySignup,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _working
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  margin: const EdgeInsets.only(top: 25, bottom: 20),
                  height: 100,
                  width: 100,
                  child: const CircleAvatar(
                    backgroundColor: appinverse,
                    child: Icon(
                      Icons.app_registration_outlined,
                      size: 70,
                    ),
                  ),
                ),
                const Text(
                  "Create Account",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: appinverse),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextBox(
                  textEditingController: username,
                  hintText: "Enter Name",
                  icondata: Icons.alternate_email,
                ),
                TextBox(
                  textEditingController: email,
                  hintText: "Enter Email",
                  icondata: Icons.email,
                ),
                TextBox(
                  textEditingController: password,
                  hintText: "Enter Password",
                  icondata: Icons.password,
                  isPassword: true,
                ),
                TextBox(
                    textEditingController: confimPassword,
                    hintText: "Confirm Password",
                    icondata: Icons.password,
                    isPassword: true),
                const SizedBox(
                  height: 5,
                ),
                StdButton(
                    btnText: 'Create Account',
                    onBtnPressed: () async {
                      setState(() {
                        _working = true;
                      });
                      if (password.text != confimPassword.text) {
                        // Fluttertoast.showToast(
                        //     msg: 'Passwords didnt matched',
                        //     toastLength: Toast.LENGTH_LONG);
                      } else {
                        bool isValid = await AuthService.signUp(
                            username.text, email.text, password.text);
                        if (isValid) {
                          // Fluttertoast.showToast(
                          //     msg: 'Account Created Successfully',
                          //     toastLength: Toast.LENGTH_LONG);
                          Navigator.pop(context);
                        } else {
                          // Fluttertoast.showToast(
                          //     msg: 'Account Creation Failed',
                          //     toastLength: Toast.LENGTH_LONG);
                        }
                      }
                      setState(() {
                        _working = false;
                      });
                    }),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ))
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
