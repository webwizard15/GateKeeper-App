import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  void uploadData(String flatId) async {
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
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Verification"),
                              content: const Text("Would you like to verify through an OTP?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    uploadData(flatId);
                                    Navigator.of(context).pop();
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
