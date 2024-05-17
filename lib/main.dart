

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/AdminScreens/admin_sign_in_screen.dart';
import 'package:gate_keeper_app/AdminScreens/towers_configuration.dart';
import 'package:gate_keeper_app/ResidentScreens/approvals_request_screens.dart';
import 'package:gate_keeper_app/SplashScreen/splash_screen.dart';
import 'package:gate_keeper_app/GuardScreens/guard_menu_screen.dart';
import 'package:gate_keeper_app/firebase_options.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart';
import 'package:gate_keeper_app/GuardScreens/guard_sign_in_screen.dart';
import 'package:gate_keeper_app/GuardScreens/visitor_form.dart';
import 'AdminScreens/registration.dart';
import 'Widgets/loader.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([  //setting whole app to potrait mode
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const SplashScreen(),
      builder: EasyLoading.init(),
    ),
  );
}

