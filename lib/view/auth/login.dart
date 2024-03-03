import 'package:bawari/utils/colors.dart';
import 'package:bawari/utils/text_styles.dart';
import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:bawari/view/widgets/custom_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    LoginController loginController = Get.put(LoginController());
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
                      controller: loginController.email,
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
                      controller: loginController.password,
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
                        if (_formKey.currentState!.validate()) {
                          loginController.userLogin();
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
