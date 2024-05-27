import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/dialogue_box.dart';

class Verification {
  static   void uploadData(String flatId, widget, BuildContext context) async {
    String? societyId = (await SharedPreferences.getInstance()).getString("society");
    String towerName = (await FirebaseFirestore.instance.collection("Towers").doc(widget.towerId).get()).get("TowerName");
    String flatNumber = (await FirebaseFirestore.instance.collection("Towers").doc(widget.towerId).collection("Flats").doc(flatId).get()).get("flatNumber");


    QuerySnapshot docsSnapshot = await FirebaseFirestore.instance.collection("resident")
        .where("tower", isEqualTo: widget.towerId).where("flat", isEqualTo: flatNumber)
        .get();


    if (docsSnapshot.docs.isNotEmpty) {
      String residentName = docsSnapshot.docs.first.get("name");
      String phoneNumber = docsSnapshot.docs.first.get("contactNumber");


      try {
        await FirebaseFirestore.instance.collection("residentVisit").doc().set({
          "name": residentName,
          "towerName": towerName,
          "flatNumber": flatNumber,
          "societyId": societyId,
          "phoneNumber": phoneNumber,
          "isExit": false,
          "isResident":true,
          "date": DateTime.now(), // Adding date and time
        });
        DialogBox.showDialogBox(context, "Entry Granted");
      } catch (e) {
        DialogBox.showDialogBox(context, e.toString());
      }
    } else {
      DialogBox.showDialogBox(context, "Resident not found");
    }
  }
   Future otpVerification(String phoneNumber, BuildContext context, String flatId, widget) async{
    FirebaseAuth firebaseAuth  = FirebaseAuth.instance;
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const otpWidget();
    //   },
    // );
    EasyLoading.show();

     await firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential cred){
          EasyLoading.dismiss();
    }, verificationFailed: (FirebaseAuthException err){
       EasyLoading.dismiss();
    }, codeSent: (String verifyId, int? resendToken){
          showDialog(context: context, builder: (context1){
            return OtpWidget(verifyId, resendToken,flatId, widget, context);
          });
       EasyLoading.dismiss();
    }, codeAutoRetrievalTimeout: (String verifyId){

    });
  }
}

class OtpWidget extends StatefulWidget {
  final String verifyId;
  final int? resendToken;
  final String flatId;
  final dynamic widgetData;
  final BuildContext context;
  const OtpWidget(this.verifyId, this.resendToken, this.flatId, this.widgetData,this.context,{super.key});

  @override
  State<OtpWidget> createState() => _otpWidgetState();
}

class _otpWidgetState extends State<OtpWidget> {
  final TextEditingController controller = TextEditingController();
  bool isError = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isError? "You have entered wrong OTP !! Please enter the correct OTP.": "Enter OTP"),
      content: TextFormField(
        controller: controller,
      ),
      actions: [
        TextButton(
          onPressed: () async{
           try {
             PhoneAuthCredential cred = PhoneAuthProvider.credential(
                 verificationId: widget.verifyId,
                 smsCode: controller.text.trim());
             UserCredential userCred = await FirebaseAuth.instance
                 .signInWithCredential(cred);
             userCred.user?.delete();
             Navigator.pop(context);
             Verification.uploadData(widget.flatId, widget.widgetData, widget.context);
           }catch(err){
             setState(() {
               isError = true;
             });
           }
          },
          child: const Text("Submit"),
        ),
        if(isError)
        TextButton(
          onPressed: () {

          },
          child: const Text("Resend OTP"),
        ),
      ],
    );
  }
}

