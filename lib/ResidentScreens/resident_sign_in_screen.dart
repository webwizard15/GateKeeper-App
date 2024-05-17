import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:gate_keeper_app/AdminScreens/admin_menu_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/resident_registration_screen.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentSignInScreen extends StatefulWidget {
  const ResidentSignInScreen({super.key});
  @override
  State<ResidentSignInScreen> createState() => _ResidentSignInScreenState();
}

class _ResidentSignInScreenState extends State<ResidentSignInScreen> {
  final _aadharController = TextEditingController();
  final _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 5),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/App.png"),
                      ),
                    ),
                  ),
                  const Text(
                    "GATE KEEPER",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Welcome\nBack",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _aadharController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Aadhar Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Phone number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(width: 30),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 28,
                    child: IconButton(
                      onPressed: () {
                        login();
                      },
                      icon: Icon(
                        Icons.arrow_right_alt,
                        size: 40,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResidentRegistration(),));
                      },
                      child: Text("Registration ?",
                        style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );


  }

  void login()async {
    String aadharNumber = _aadharController.text.trim();
    String email = "$aadharNumber@gmail.com";
    String phoneNumber = _phoneController.text.trim();
    if (email.isEmpty || phoneNumber.isEmpty) {
      DialogBox.showDialogBox(context, "Please fill all the Details.");
      return;
    }
    try {
      UserCredential userCredential =  await FirebaseAuth.instance           //sign in and return userInfo
          .signInWithEmailAndPassword(
        email: email,
        password: phoneNumber, // Use a dummy password or another authentication method
      );
      if(userCredential.user!.email != null){
        QuerySnapshot  data =   await FirebaseFirestore.instance.collection("resident").where("aadhar",isEqualTo: userCredential.user!.email!.replaceAll("@gmail.com", '')).get();
        final SharedPreferences _prefs = await SharedPreferences.getInstance(); //calling sharedPreference instance
        Map? userData =  data.docs[0].data() as Map<String,dynamic>;  //converting obj to Map
        if(userData["type"] == 1){    // admin
          _prefs.setString("userId", data.docs[0].id);    //Stored Id in shared Preference
           _prefs.setInt("type", userData["type"]);
           _prefs.setString("society", userData["society"]);
          //Stored type in shared Preference
          Navigator.popUntil(context, (route) => false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ResidentMenuScreen()));


        }else{
          DialogBox.showDialogBox(context, "Don't have resident access");
        }


      }




    } catch (e) {
      if(e is FirebaseAuthException){
        if(e.code == "user-not-found"){
          DialogBox.showDialogBox(context, "User Not Found");
        } else{
          DialogBox.showDialogBox(context, "Invalid Credentials");
          return;
        }
      } else{
        DialogBox.showDialogBox(context,"An Error Occurred");
      }
    }
  }
}
