

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/ResidentScreens/approvals_request_screens.dart';
import 'package:gate_keeper_app/ResidentScreens/complaint.dart';
import 'package:gate_keeper_app/ResidentScreens/notice_list.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_sign_in_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/society_details.dart';
import 'package:gate_keeper_app/ResidentScreens/visitor_list.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentMenuScreen extends StatelessWidget{
  const ResidentMenuScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration:BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                spreadRadius: 5,
                offset:const Offset(0,3)
              ),
            ]
          ),
          child: AppBar(),
        ),
      ),
      drawer: Drawer(
          width: 200,
        child: ListView(
          children: [
              const  DrawerHeader(
                  padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:AssetImage("assets/Man.png"),
                      radius: 50,
                    ),
                   Padding(
                     padding: EdgeInsets.only(top:10.0),
                     child: Text("Anmol Shukla",
                       style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),
                      ),
                   )
                  ],
                ),
            ),
            ListTile(
              leading: const Icon(Icons.event_note_outlined, size:25),
              title:const Text("Complaints",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: const Icon(Icons.people, size:25),
              title:const Text("Visitors",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => const VisitorList(),));
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone_android, size:25),
              title:const Text("Contact us",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) =>const  SocietyDetails(),),);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size:25),
              title:const Text("Log Out",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: ()async{

                FirebaseAuth.instance.signOut();
                (await SharedPreferences.getInstance()).clear();
                Navigator.popUntil(context, (route) => false);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const MenuScreen()));
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ResidentSignInScreen()));

              },
            ),
           const  Divider(
              thickness:2,
              endIndent: 8,
              indent: 8
              ,
            ),
          ],
        )
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: Column(
            children: [
             ElevatedButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => RequestApprovalScreen(),));
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
                       image: AssetImage(
                         "assets/Approvals.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
             const  Text("Approvals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const NoticeList(),));
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
                       image: AssetImage(
                         "assets/Notice.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
             const Text("Notice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const ComplaintScreen(),));
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
                       image: AssetImage(
                         "assets/Report.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
               const  Text("Complaints",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}