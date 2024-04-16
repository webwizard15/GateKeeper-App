import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gate_keeper_app/AdminScreens/admin_sign_in_screen.dart';
import 'package:gate_keeper_app/SplashScreen/splash_screen.dart';
import 'package:gate_keeper_app/GuardScreens/guard_menu_screen.dart';
import 'package:gate_keeper_app/firebase_options.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart';
import 'package:gate_keeper_app/GuardScreens/guard_sign_in_screen.dart';
import 'package:gate_keeper_app/GuardScreens/visitor_form.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    ),
  );
}

