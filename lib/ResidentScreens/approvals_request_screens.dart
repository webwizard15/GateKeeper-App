import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestApprovalScreen extends StatefulWidget {
  const RequestApprovalScreen({super.key});
  @override
  State<RequestApprovalScreen> createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApprovalScreen> {
  String? residentTowerId;
  String? residentFlatNumber;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? residentUserId = prefs.getString("userId");

    if (residentUserId != null) {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection("resident")
          .doc(residentUserId)
          .get();
      setState(() {
        residentTowerId = documentSnapshot.get("tower");
        residentFlatNumber = documentSnapshot.get("flat");
      });
    }
  }

  Future<void> updateVisitorStatus(String id, String status) async {
    await FirebaseFirestore.instance.collection("Visitors").doc(id).update({
        "status": status,
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
                blurRadius: 7,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              "Approvals",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: residentTowerId == null || residentFlatNumber == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Visitors")
                    .where("towerId", isEqualTo: residentTowerId)
                    .where("flatNumber", isEqualTo: residentFlatNumber)
                    .where("status",isEqualTo: "Pending")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Center(child: Text("No Pending Requests..", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)));
                  } else {
                    final visitors = snapshot.data!.docs.reversed.toList();
                    return ListView.builder(
                      itemCount: visitors.length,
                      itemBuilder: (context, index) {
                        final visitor = visitors[index];
                        Timestamp dateTime = visitor["timestamp"];
                        DateTime date = dateTime.toDate();
                        String formattedDate = DateFormat('dd-MM-yyyy / hh:mm').format(date);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            elevation: 5,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        NetworkImage(visitor["profilePic"]),
                                  ),
                                  title: Text(
                                    visitor["name"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    visitor["purpose"],
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      final Uri visitorNumber = Uri.parse(
                                          "tel:${visitor["contactNumber"]}");
                                      launchUrl(visitorNumber);
                                    },
                                    icon: const Icon(Icons.phone, size: 20),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            updateVisitorStatus(
                                                visitor.id, "Approved");
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.green),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Approve",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            updateVisitorStatus(
                                                visitor.id, "Denied");
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          child: const Text(
                                            "Deny",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const SizedBox(width: 5,),
                                    Text(formattedDate, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),),
                                    const SizedBox(width: 30,),
                                  ],
                                ),
                                const SizedBox(height:5,)
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
