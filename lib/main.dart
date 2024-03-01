import 'package:bawari/firebase_options.dart';
import 'package:bawari/view/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'services/purchase_service.dart';
// Firebase database variable
FirebaseFirestore db = FirebaseFirestore.instance;

// Services
PurchaseService purchaseService = PurchaseService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(33, 158, 188, 1)),
        useMaterial3: true,
        textTheme: GoogleFonts.almaraiTextTheme(), 
      ),
      home:  LoginScreen(),
    );
  }
}
