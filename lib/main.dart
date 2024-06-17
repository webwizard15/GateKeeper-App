

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'AdminScreens/registration.dart';
import 'Widgets/loader.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

final  navigatorKey = GlobalKey<NavigatorState>();
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  // await ZegoExpressEngine.createEngineWithProfile(ZegoEngineProfile(
  //   1249166214,
  //   ZegoScenario.StandardVoiceCall,
  //   appSign: '1cbb00886334c928a77bc4903cf93a69ff557f89f44071cf4ddff2dbc47ed66d',
  // ));

  /// 1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  SystemChrome.setPreferredOrientations([ //setting whole app to potrait mode
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  // call the useSystemCallingUI
  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );

  await _getToken();
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: Builder(
          builder: (context) {
            return
              const SplashScreen();
          },
        ),
        builder: EasyLoading.init(),
      ),
    );
  });
}

 _getToken() async {
  FirebaseMessaging firebaseIns = FirebaseMessaging.instance;
  await firebaseIns.requestPermission();

  String? token = await firebaseIns.getToken();
  if(token != null) {
    (await SharedPreferences.getInstance()).setString('fcmToken', token);
    print(token);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMsg);
    FirebaseMessaging.onMessage.listen(handleBackgroundMsg);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true,badge: true,sound: true);
  }
}

Future<void> handleBackgroundMsg(RemoteMessage message) async{
  print('Title: ${message.notification?.title}');
}


