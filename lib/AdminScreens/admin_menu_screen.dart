import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/add_employee.dart';
import 'package:gate_keeper_app/AdminScreens/admin_sign_in_screen.dart';
import 'package:gate_keeper_app/AdminScreens/maid_list.dart';
import 'package:gate_keeper_app/AdminScreens/notice_screen.dart';
import 'package:gate_keeper_app/AdminScreens/registration.dart';
import 'package:gate_keeper_app/AdminScreens/resident_approval.dart';
import 'package:gate_keeper_app/Guardscreens/guard_menu_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});
  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  @override
  Widget build(BuildContext context) {

    // SharedPreferences.getInstance().then((SharedPreferences shared){
    //   if(shared.getString("userId") == null || shared.getString("userId") == ''){
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MenuScreen())) ;
    //   }
    // });
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
            elevation: 0,
            title: const Text(
              "Management Portal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          children: [
            const DrawerHeader(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/Man.png"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Admin", // Should not exceed ore than 18 words
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note_outlined, size: 25),
              title: const Text(
                "Notice",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Notice(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_work_outlined, size: 25),
              title: const Text(
                "Towers/Flats",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) =>const SocietyRegistration(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 25),
              title: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () async{
                SharedPreferences shared= await SharedPreferences.getInstance();
                shared.clear();   //it will clear the id
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => false); // it will clear the stack.
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuScreen()));
                Navigator.push(context, MaterialPageRoute(builder: (context) =>const AdminSignInScreen(),));
              },
            ),
            const Divider(
              thickness: 2,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
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
                        builder: (context) => AddEmployee(),
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
                        image: AssetImage("assets/Guard.png"),
                        fit: BoxFit
                            .contain, // Use BoxFit.contain or BoxFit.scaleDown
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Employee",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>const ResidentApprovalScreen(),));
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
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const MaidListScreen(),));
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
                    // Add your onPressed logic here
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
                        image: AssetImage("assets/Report.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Complaints",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        
              ],
            )
          ],
        ),
      ),
    );
  }
}
