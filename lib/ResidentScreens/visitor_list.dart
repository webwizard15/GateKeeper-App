import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorList extends StatefulWidget {
  const VisitorList({super.key});

  @override
  State<VisitorList> createState() => _VisitorListState();
}

class _VisitorListState extends State<VisitorList> {
  String? towerId;
  String? flatName;
  String? societyId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? society = prefs.getString("society");
      final String? userId = prefs.getString("userId");

      if (userId == null) {
        throw Exception("User ID not found in SharedPreferences");
      }

      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("resident")
          .doc(userId)
          .get();

      if (!doc.exists) {
        throw Exception("Resident document not found");
      }

      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      setState(() {
        societyId = society;
        flatName = data["flat"];
        towerId = data["tower"];
      });
    } catch (error) {
      print("Error initializing data: $error");
      // Handle the error as appropriate in your app
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
            centerTitle: true,
            title: const Text('Visitor List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
        ),
      ),
      body: towerId == null || flatName == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Visitors")
            .where("SocietyId", isEqualTo: societyId)
            .where("towerId", isEqualTo: towerId)
            .where("flatNumber", isEqualTo: flatName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            final docs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index].data() as Map<String, dynamic>;
                final String picture = doc["profilePic"];
                final String name = doc["name"];
                final String phoneNumber = doc["contactNumber"];
                final String purpose = doc["purpose"];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(picture),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        purpose,
                        maxLines: 1,
                      ),
                      trailing: GestureDetector(
                        onTap: (){
                          Uri uri = Uri.parse("tel: $phoneNumber");
                          launchUrl(uri);
                        },
                          child: Text(phoneNumber, style:const TextStyle(fontStyle: FontStyle.italic, color: Colors.blue, decoration: TextDecoration.underline),)
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
