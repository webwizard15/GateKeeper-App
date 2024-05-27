import 'package:flutter/Material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({super.key, required this.callID, required this.userId, required this.userName});
  final String callID;
  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1010249672, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: '1c1dad81f5551368150befd8cb581df04cf03d5161f1fee95f2ebd4a7970e742', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userId,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
    );
  }
}
