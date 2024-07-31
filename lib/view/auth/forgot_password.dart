import 'package:bawari/view/auth/login.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/text_styles.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: primaryColor,
          content: Text(
            'Password Reset Email has been sent !',
            style: boldTextStyle(),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: primaryColor,
            content: Text(
              'No user found for that email.',
              style: boldTextStyle(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "پټنوم بیا تنظیم کړئ",
          style: boldTextStyle(),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin:  EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
            child: Text(
              'د بیا تنظیم کولو لینک به ستاسو بریښنالیک ته واستول شي!',
              style: boldTextStyle(size: 20),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: ListView(
                children: [
                  TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(
                          color: Colors.redAccent, fontSize: 15),
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
                  
                  SizedBox(height: defaultPadding,),
                  CustomButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, otherwise false.
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          email = emailController.text;
                        });
                        resetPassword();
                      }
                    },
                    label: "برېښنا لیک ولېږه",
                  ),
                  CustomButton(
                    onPressed: () => {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, a, b) =>
                                const LoginScreen(),
                            transitionDuration: const Duration(seconds: 0),
                          ),
                          (route) => false)
                    },
                    label: "د ننه کیدل",backgroundColor: secondaryColor,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Don't have an Account? "),
                  //     TextButton(
                  //         onPressed: () => {
                  //               Navigator.pushAndRemoveUntil(
                  //                   context,
                  //                   PageRouteBuilder(
                  //                     pageBuilder: (context, a, b) =>
                  //                         Signup(),
                  //                     transitionDuration:
                  //                         const Duration(seconds: 0),
                  //                   ),
                  //                   (route) => false)
                  //             },
                  //         child: const Text('Signup'))
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
