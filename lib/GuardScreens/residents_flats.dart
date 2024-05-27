import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/GuardScreens/otp_verification.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentFlats extends StatefulWidget {
  const ResidentFlats({super.key, required this.towerId});
  final String towerId;

  @override
  State<ResidentFlats> createState() => _ResidentFlatsState();
}

class _ResidentFlatsState extends State<ResidentFlats> {


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
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            title: const Text(
              "Flats",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Towers").doc(widget.towerId).collection("Flats").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final docs = snapshot.data!.docs;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  String flatName = docs[index]["flatNumber"];
                  String flatId = docs[index].id;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context1) {
                            return AlertDialog(
                              title: const Text("Verification"),
                              content: const Text("Would you like to verify through an OTP?"),
                              actions: [
                                TextButton(
                                  onPressed: () async{
                                    QuerySnapshot docsSnapshot = await FirebaseFirestore.instance.collection("resident")
                                        .where("tower", isEqualTo: widget.towerId).where("flat", isEqualTo: flatName)
                                        .get();
                                    String phoneNumber = docsSnapshot.docs.first.get("contactNumber");
                                    Verification().otpVerification(phoneNumber, context, flatId,widget);
                                    Navigator.of(context1).pop();
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Verification.uploadData(flatId,widget,context);
                                    Navigator.of(context1).pop();
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        flatName,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
