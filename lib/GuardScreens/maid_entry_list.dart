import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../Widgets/dialogue_box.dart";

class MaidEntryList extends StatefulWidget {
  const MaidEntryList({super.key});

  @override
  State<MaidEntryList> createState() => _MaidEntryListState();
}

class _MaidEntryListState extends State<MaidEntryList> {
  String? societyId;

  void updateData(String? societyId, String profilePicture, String name, String phoneNumber) async {
     QuerySnapshot document= await FirebaseFirestore.instance.collection("residentVisit").where("societyId", isEqualTo:societyId ).where("contactNumber", isEqualTo: phoneNumber).where("isExit", isEqualTo: false).get();
   if(document.docs.isNotEmpty){
     DialogBox.showDialogBox(context, "Already Permitted");
     return;
   }
    await FirebaseFirestore.instance.collection("residentVisit").doc().set({
        "profilePicture": profilePicture,
      "name": name,
      "societyId": societyId,
      "contactNumber": phoneNumber,
      "isExit":false,
      "isMaid": true,
      "entryDate": DateTime.now(),
    });
   DialogBox.showDialogBox(context, "Entry Granted");
  }

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    String? userSocietyId = (await SharedPreferences.getInstance()).getString("society");
    setState(() {
      societyId = userSocietyId;
    });
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
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20, bottom: 20, left: 10, right: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Maids")
              .where("SocietyId", isEqualTo: societyId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final docs = snapshot.data?.docs.toList();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: docs!.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  String picture = doc["profilePic"];
                  String name = doc["name"];
                  String contactNumber= doc["contactNumber"];
                  String id = doc.id;
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Entry"),
                          content: Text(
                            "Tap Yes to allow $name",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                updateData(societyId,picture, name, contactNumber);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Yes",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(picture),
                            radius: 60,
                          ),
                          Text(
                            name,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
