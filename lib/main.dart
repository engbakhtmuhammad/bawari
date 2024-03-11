import 'package:bawari/firebase_options.dart';
import 'package:bawari/model/invoice.dart';
import 'package:bawari/utils/routes.dart';
import 'package:bawari/view/auth/login.dart';
import 'package:bawari/view/dashboard/dashboard.dart';
import 'package:bawari/view/invoice2/invoice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return GetMaterialApp(
      title: 'Bawary Zari Sharkat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromRGBO(33, 158, 188, 1)),
        useMaterial3: true,
        textTheme: GoogleFonts.almaraiTextTheme(), 
      ),
      getPages: pages,
      home:   InvoiceScreen(),
    );
  }
}
