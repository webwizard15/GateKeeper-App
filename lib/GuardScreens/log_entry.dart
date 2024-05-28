import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/GuardScreens/voiceCalling.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LogEntryList extends StatefulWidget {
  const LogEntryList({super.key});

  @override
  State<LogEntryList> createState() => _LogEntryListState();
}

class _LogEntryListState extends State<LogEntryList> {
  String? societyId;

  void updateData(String? id) async {
    await FirebaseFirestore.instance.collection("Visitors").doc(id).update({
      "status": "Exit",
      "exitDate": Timestamp.now(),
    });
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
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Visitors").where("SocietyId", isEqualTo: societyId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final docs = snapshot.data?.docs.toList();
              if (docs == null || docs.isEmpty) {
                return const Center(child: Text('No data available'));
              }
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  String picture = snapshot.data?.docs[index]["profilePic"];
                  String purpose = snapshot.data?.docs[index]["purpose"];
                  String name = snapshot.data?.docs[index]["name"];
                  String? visitorId = snapshot.data?.docs[index].id;
                  String phoneNumber = snapshot.data?.docs[index]["contactNumber"];
                  String statusValue = snapshot.data?.docs[index]["status"];
                  String towerName = snapshot.data?.docs[index]["towerName"];
                  String flatNumber = snapshot.data?.docs[index]["flatNumber"];
                  String towerId = snapshot.data?.docs[index]["towerId"];
                  Timestamp dateTime = snapshot.data?.docs[index]["timestamp"];
                  DateTime date = dateTime.toDate();
                  String formattedDate = DateFormat('dd-MM-yyyy / hh:mm').format(date);

                  // Exit date formatting
                  String? exitDateFormatted;
                  if (statusValue == "Exit") {
                    Timestamp exitTimestamp = snapshot.data?.docs[index]["exitDate"];
                    DateTime exitDate = exitTimestamp.toDate();
                    exitDateFormatted = DateFormat('dd-MM-yyyy / hh:mm').format(exitDate);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(picture),
                            ),
                            const SizedBox(width: 10),
                            // Name, Purpose, and Status
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                  const SizedBox(height: 5,),
                                  Text(purpose, maxLines: 1),
                                  const SizedBox(height: 5,),
                                  Text(statusValue, style: TextStyle(color: statusValue == "Pending" ? Colors.orange : statusValue == "Approved" ? Colors.green : Colors.red)),
                                  const SizedBox(height: 5,),
                                  GestureDetector(
                                    onTap: () async {
                                      Uri contact = Uri.parse("tel:$phoneNumber");
                                      await launchUrl(contact);
                                    },
                                    child: Text(phoneNumber, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.blue)),
                                  ),
                                  const SizedBox(height: 5,),
                                  Text('Entry: $formattedDate', style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.normal)),
                                  if (exitDateFormatted != null)
                                    Text('Exited: $exitDateFormatted', style: const TextStyle(fontSize: 10, color: Colors.red)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Tower Name, Flat Number, and Icon Button
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(height: 5,),
                                  Text(towerName),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(flatNumber),
                                      const SizedBox(width: 15,),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                              .collection("resident")
                                              .where("tower", isEqualTo: towerId)
                                              .where("flat", isEqualTo: flatNumber)
                                              .get();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CallPage(
                                                callID: querySnapshot.docs[0].id,
                                                userId: querySnapshot.docs[0].id,
                                                userName: querySnapshot.docs[0]["name"],
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Icon(Icons.phone, size: 18),
                                      ),
                                      const SizedBox(width: 15,)
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  if (statusValue == "Approved")
                                    ElevatedButton(
                                      onPressed: () {
                                        updateData(visitorId);
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.red),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 5, horizontal: 8)),
                                        textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14)),
                                      ),
                                      child: const Text(
                                        "EXIT",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
