import 'package:connect_z/common/textbox.dart';
import 'package:connect_z/common/custom_button.dart';
import 'package:connect_z/constants/constants.dart';
import 'package:connect_z/pages/auth_pages/signup_page.dart';
import 'package:connect_z/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey formkeyLogin = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var _working = false;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formkeyLogin,
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
                  margin: const EdgeInsets.only(bottom: 25),
                  height: 100,
                  width: 100,
                  child: const CircleAvatar(
                    backgroundColor: appinverse,
                    child: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 70,
                    ),
                  ),
                ),
                const Text(
                  "Login Here",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: appinverse,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextBox(
                  textEditingController: email,
                  hintText: "Enter Email",
                  icondata: Icons.email,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextBox(
                  textEditingController: password,
                  hintText: "Enter Password",
                  icondata: Icons.password_rounded,
                  isPassword: true,
                ),
                StdButton(
                    btnText: 'Log In',
                    onBtnPressed: () async {
                      setState(() {
                        _working = true;
                      });
                      bool isValid =
                          await AuthService.logIn(email.text, password.text);
                      if (isValid) {
                        // Fluttertoast.showToast(
                        //     msg: 'Processing Request....',
                        //     toastLength: Toast.LENGTH_LONG);
                        // // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {
                        // Fluttertoast.showToast(
                        //     msg: 'Login Failed! Please Try Again.',
                        //     toastLength: Toast.LENGTH_LONG);
                      }
                      setState(() {
                        _working = false;
                      });
                    }),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    "Dont You Have An Account?",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      child: const Text(
                        "Create Account",
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
