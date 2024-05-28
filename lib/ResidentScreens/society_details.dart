import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/dialogue_box.dart';

class SocietyDetails extends StatefulWidget {
  const SocietyDetails({super.key});

  @override
  State<SocietyDetails> createState() => _SocietyDetailsState();
}

class _SocietyDetailsState extends State<SocietyDetails> {
  String? societyId;
  String? adminName;
  String? adminEmail;
  String? adminPhoneNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? societyUserId = prefs.getString("society");

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("admins")
          .where("id", isEqualTo: societyUserId)
          .get();

      final DocumentSnapshot doc = querySnapshot.docs.first;
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        societyId = societyUserId;
        adminName = data["name"];
        adminPhoneNumber = data["phoneNo"];
        adminEmail = data["email"];
        isLoading = false;
      });
    } catch (error) {
       DialogBox.showDialogBox(context, "Error initializing Data");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
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
                spreadRadius: 7,
                blurRadius: 5,
                offset: const Offset(0, 3),
                color: Colors.grey.withOpacity(0.5),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Society Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : societyId == null || adminName == null || adminEmail == null || adminPhoneNumber == null
          ? const Center(
        child: Text(
          "Failed to load data. Please try again.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("Society")
                .where("adminId", isEqualTo: societyId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Expanded(
                  child: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }

              final doc = snapshot.data!.docs.first;
              final String societyName = doc["SocietyName"];
              final String societyAddress = doc["SocietyAddress"];
              final String societyEmailId = doc["SocietyEmailID"];
              final String societyTowers = doc["SocietyTowers"];
              final String state = doc["State"];
              final String city = doc["City"];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        societyName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          societyEmailId,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.deepPurple,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      Text(
                        "$societyAddress\n$city, $state,",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Administrative Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            adminName!,
                            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.email, size: 18),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => _launchEmail(adminEmail!),
                            child: Text(
                              adminEmail!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, size: 18),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => _launchPhone(adminPhoneNumber!),
                            child: Text(
                              adminPhoneNumber!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        height: 200,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/Building.png"),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
