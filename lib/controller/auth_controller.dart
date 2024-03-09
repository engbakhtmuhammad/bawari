import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class LoginController extends GetxController{
  final email = TextEditingController(text: "salih@bawary.com");
  final password = TextEditingController();

   userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: password.text);
          Get.offAll(DashboardScrreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No User Found for that Email");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong Password Provided by User");
      }
    }
  }

}

class SignupController extends GetxController{
  
}
class ForgotPwdController extends GetxController{
  
}