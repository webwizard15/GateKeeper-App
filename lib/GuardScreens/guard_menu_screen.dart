import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:gate_keeper_app/GuardScreens/guard_sign_in_screen.dart';
import 'package:gate_keeper_app/GuardScreens/log_entry.dart';
import 'package:gate_keeper_app/GuardScreens/maid_entry_list.dart';
import 'package:gate_keeper_app/GuardScreens/resident_maid_logs.dart';
import 'package:gate_keeper_app/GuardScreens/resident_towers.dart';
import 'package:gate_keeper_app/GuardScreens/visitor_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../screens/menu_screen.dart';

class GuardMenu extends StatefulWidget {
  const GuardMenu({super.key});

  @override
  State<GuardMenu> createState() => _GuardMenuState();
}

class _GuardMenuState extends State<GuardMenu> {
  String? picture;
  String? guardName;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    String? guardUserId = (await SharedPreferences.getInstance()).getString("userId");
    if (guardUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection("Guards").doc(guardUserId).get();
      String profilePic = doc["profilePic"];
      String name = doc["name"];
      ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1010249672, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: '1c1dad81f5551368150befd8cb581df04cf03d5161f1fee95f2ebd4a7970e742', // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: guardUserId,
        userName: name,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
      setState(() {
        picture = profilePic;
        guardName = name;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //creating customise tool bar
        preferredSize:
            const Size.fromHeight(kToolbarHeight), //setting standard height
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ), // App bar color
            elevation: 0, // Remove default app bar elevation
          ),
        ),
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          children: [
             DrawerHeader(
              padding:const EdgeInsets.all(10),
              //first is header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(picture!= null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(picture!),
                    radius: 50,
                  )
                  else
                    const CircularProgressIndicator(),
                  if(guardName!= null)
                  Padding(
                    padding:const  EdgeInsets.only(top: 10.0),
                    child: Text(
                      guardName!,
                      style: const TextStyle(fontWeight: FontWeight.bold,),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.house,
                size: 20,
              ),
              title: const Text(
                "Maids/Residents",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const ResidentMaidsLogs(),));
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 20,
              ),
              title: const Text(
                "Log Out",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              onTap: () async{
                SharedPreferences shared= await SharedPreferences.getInstance();
                shared.clear();   //it will clear the id
                FirebaseAuth.instance.signOut();
                ZegoUIKitPrebuiltCallInvitationService().uninit();
                Navigator.popUntil(context, (route) => false); // it will clear the stack.
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuScreen()));
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const GuardSignInScreen(),));
              },
            ),
            const Divider(
              thickness: 2,
              indent: 8,
              endIndent: 8,
            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const VisitorForm(),
                    ),
                  );
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Visitor.png"),
                      fit: BoxFit
                          .contain, // Use BoxFit.contain or BoxFit.scaleDown
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Visitors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const ResidentTower(),));
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Resident.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Resident",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            children: [
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MaidEntryList(),));
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/Maid.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Maid",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LogEntryList(),));
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/LogEntry.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "LogEntry",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}
