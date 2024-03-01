import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/common.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLoginScreen() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScrreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              "No User Found for that Email",
              style: boldTextStyle(),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              "Wrong Password Provided by User",
              style: boldTextStyle(),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .3,
                      child: Image.asset(
                        "assets/icons/id.png",
                        fit: BoxFit.cover,
                      )),
                  Text("ښه راغلاست",
                    style: boldTextStyle(color: secondaryColor,size: 20),textAlign: TextAlign.center,
                  ),
                  Text("د ننه کیدل",
                    style: boldTextStyle(color: secondaryColor),textAlign: TextAlign.center,
                  ),
                  SizedBox(height: defaultPadding,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2.5),
                    child: TextFormField(
                      controller: emailController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        errorStyle:
                            const TextStyle(color: Colors.redAccent, fontSize: 15),
                        suffixIcon: Image.asset(
                          "assets/icons/customer.png",
                          width: defaultIconsSize,
                          height: defaultIconsSize,
                        ),
                        hintText: "ایمیل",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مهرباني وکړئ بریښنالیک دننه کړئ';
                        } else if (!value.contains('@')) {
                          return 'مهرباني وکړئ باوري بریښنالیک دننه کړئ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding / 2.5),
                    child: TextFormField(
                      autofocus: false,
                      obscureText: true,
                      controller: passwordController,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        errorStyle:
                            const TextStyle(color: Colors.redAccent, fontSize: 15),
                        suffixIcon: Image.asset(
                          "assets/icons/secure.png",
                          width: defaultIconsSize,
                          height: defaultIconsSize,
                        ),
                        hintText: "رمز",
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'مهرباني وکړئ پاسورډ دننه کړئ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            ),
                        child: Text(
                          "خپل پټ نوم درڅخه هیر دی",
                          style: primaryTextStyle(color: primaryColor),
                        )),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: defaultPadding),
                    child: CustomButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, otherwise false.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          userLoginScreen();
                        }
                      },
                      label: "د ننه کیدل",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
