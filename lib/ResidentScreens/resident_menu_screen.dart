import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/GuardScreens/voiceCalling.dart';
import 'package:gate_keeper_app/ResidentScreens/approvals_request_screens.dart';
import 'package:gate_keeper_app/ResidentScreens/complaint.dart';
import 'package:gate_keeper_app/ResidentScreens/notice_list.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_sign_in_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/residents_complaints_list.dart';
import 'package:gate_keeper_app/ResidentScreens/society_details.dart';
import 'package:gate_keeper_app/ResidentScreens/visitor_list.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ResidentMenuScreen extends StatefulWidget {
  const ResidentMenuScreen({super.key});

  @override
  State<ResidentMenuScreen> createState() => _ResidentMenuScreenState();
}

class _ResidentMenuScreenState extends State<ResidentMenuScreen> {
  String? picture;
  String? residentName;
  String? towerName;
  String? flatNumber;
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    String? residentUserId = (await SharedPreferences.getInstance()).getString("userId");
    if (residentUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("resident").doc(residentUserId).get();
      String profilePic = doc["profilepic"];
      String name = doc["name"];
      String flat = doc["flat"];
      String tower = doc["towerName"];
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1010249672, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: '1c1dad81f5551368150befd8cb581df04cf03d5161f1fee95f2ebd4a7970e742', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: residentUserId,
        userName: name,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
      setState(() {
        picture = profilePic;
        residentName = name;
        towerName = tower;
        flatNumber = flat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: Text("$towerName / $flatNumber", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  if (picture != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(picture!),
                      radius: 50,
                    )
                  else
                    const CircularProgressIndicator(),
                  if (residentName != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        residentName!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event_note_outlined, size: 25),
              title: const Text(
                "Complaints",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ResidentsComplaintsLog()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, size: 25),
              title: const Text(
                "Visitors",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitorList()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, size: 25),
              title: const Text(
                "Contact us",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SocietyDetails()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 25),
              title: const Text(
                "Log Out",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: () async {
                FirebaseAuth.instance.signOut();
                (await SharedPreferences.getInstance()).clear();
                ZegoUIKitPrebuiltCallInvitationService().uninit();
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ResidentSignInScreen()));
              },
            ),
            const Divider(
              thickness: 2,
              endIndent: 8,
              indent: 8,
            ),
          ],
        ),
      ),
      body:
      Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RequestApprovalScreen()));
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Container(
                        height: 150,
                        width: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Approvals.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Approvals",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeList()));
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Container(
                        height: 150,
                        width: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Notice.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Notice",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ComplaintScreen()));
                      },
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(10),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      child: Container(
                        height: 150,
                        width: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Report.png"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Complaints",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top:0, child: SizedBox(width: MediaQuery.of(context).size.width, child: const Center(child: ReciveCalls(),),)),
        ],
      ),

    );
  }
}
