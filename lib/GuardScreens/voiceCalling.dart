import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:collection/collection.dart';

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


class ReciveCalls extends StatefulWidget {
  const ReciveCalls({super.key});

  @override
  State<ReciveCalls> createState() => _ReciveCallsState();
}

class _ReciveCallsState extends State<ReciveCalls> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: (SharedPreferences.getInstance()), builder: (context, sharedPref){
      if(sharedPref.hasData && sharedPref.connectionState == ConnectionState.done){

        return StreamBuilder(stream: FirebaseFirestore.instance.collection("calling").snapshots(), builder: (context,snapshot){
          String? userId = sharedPref.data?.getString("userId");
          if(userId == null || userId == ''){
            return const SizedBox.shrink();
          }
          if(snapshot.hasData && (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active)){
            DocumentSnapshot? data = snapshot.data?.docs.firstWhereOrNull((DocumentSnapshot doc){
              Map data = doc.data() as Map;
              return data['resId'] == userId && data['callRecived'] != true && data['callRejected'] != true;

            });
            if(data != null && data.exists){
              
              return FutureBuilder(future: FirebaseFirestore.instance.collection('Guards').doc(data['guardId']).get(), builder: (context, guardSnapshot){
                if(guardSnapshot.data != null && guardSnapshot.hasData && (guardSnapshot.connectionState == ConnectionState.active || guardSnapshot.connectionState == ConnectionState.done)){
                  Map guardData = guardSnapshot.data!.data() as Map;
                  return Container(
                    width: 300,
                    height: 150,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 24.0,
                              backgroundImage: NetworkImage(guardData['profilePic']),
                            ),
                            SizedBox(width: 16.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Incoming Call',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  guardData['name'],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.call_end, color: Colors.red),
                              onPressed: () async{
                                await FirebaseFirestore.instance.collection("calling").doc(data.id).update({
                                  'callRecived': false,
                                  'callRejected':true,
                                });
                                // Handle decline call
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.call, color: Colors.green),
                              onPressed: (){
                                 FirebaseFirestore.instance.collection("calling").doc(data.id).update({
                                  'callRecived': true,
                                  'callRejected':false,
                                });
                                // doc.docs
                                Map res = data.data() as Map;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CallPage(callID: userId, userId:res['callID'] , userName:userId )));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              });
            }

          }
          return const SizedBox.shrink();
        });
      }
      return const SizedBox.shrink();
    });

  }
}
