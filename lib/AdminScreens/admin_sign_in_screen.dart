import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart.';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/AdminScreens/admin_menu_screen.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({super.key});
  @override
  State<AdminSignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<AdminSignInScreen> {
  final _aadharController = TextEditingController();
  final _phoneController = TextEditingController();

  void login()async {
    String aadharNumber = _aadharController.text.trim();
    String email = "$aadharNumber@gmail.com";
    String phoneNumber = _phoneController.text.trim();
    if (aadharNumber.isEmpty || phoneNumber.isEmpty) {
      DialogBox.showDialogBox(context, "Please fill all the Details.");
      return;
    }
    try {
      EasyLoading.show();
      UserCredential userCredential =  await FirebaseAuth.instance           //sign in and return userInfo
          .signInWithEmailAndPassword(
        email: email,
        password: phoneNumber, // Use a dummy password or another authentication method
      );
      if(userCredential.user!.uid.isNotEmpty){
        DocumentSnapshot  data =   await FirebaseFirestore.instance.collection("admins").doc(userCredential.user!.uid).get();
        final SharedPreferences _prefs = await SharedPreferences.getInstance(); //calling sharedPreference instance
        Map? userData =  data.data() as Map<String,dynamic>;  //converting obj to Map
        if(userData["type"] == 0){    // admin
          _prefs.setString("userId", userData["id"]);    //Stored Id in shared Preference
          _prefs.setInt("type", userData["type"]); //Stored type in shared Preference
          Navigator.popUntil(context, (route) => false);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AdminMenuScreen()));
          EasyLoading.dismiss();

        }else{
          DialogBox.showDialogBox(context, "Don't have admin access");
          EasyLoading.dismiss();
        }

      }




    } catch (e) {
      if(e is FirebaseAuthException){
        if(e.code == "user-not-found"){
          DialogBox.showDialogBox(context, "User Not Found");
          EasyLoading.dismiss();
        } else{
          DialogBox.showDialogBox(context, "Invalid Credentials");
          EasyLoading.dismiss();
          return;
        }
      } else{
        DialogBox.showDialogBox(context,e.toString());
        EasyLoading.dismiss();
      }
    }
  }

  @override
  void initState() {
    //   Q) Why am i calling a init state here?
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences value){   //below widget will only render once the id in share preference is null
      String? id = value.getString("userId");
      if(id != null && id != "" ){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AdminMenuScreen()));   //until and unless you are logged out login screen won't appear
      }
    });
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 30, right: 30, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:const EdgeInsets.only(top: 40, left: 5),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      image:
                      DecorationImage(image: AssetImage("assets/App.png")
                        ,),
                    )
                    ,
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
                    labelText: "Aadhaar Number",
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:25,
                    ),
                  ),
                  const SizedBox(width: 30),
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 28,
                    child: IconButton(
                      onPressed: (){
                        login();
                      },
                      icon:Icon(Icons.arrow_right_alt,
                        size: 40,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}

