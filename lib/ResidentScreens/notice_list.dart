import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/ResidentScreens/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeList extends StatefulWidget {
  const NoticeList({super.key});

  @override
  State<NoticeList> createState() => _NoticeListState();
}

class _NoticeListState extends State<NoticeList> {
  String? societyUserId;
  String? towerId;
  String? flat;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    final prefs = await SharedPreferences.getInstance();
    final societyId = prefs.getString("society");
    final residentUserId = prefs.getString("userId");

    if (residentUserId != null) {
      final doc = await FirebaseFirestore.instance.collection("resident").doc(residentUserId).get();
      final tower = doc["tower"];
      final flatNumber = doc["flat"];

      setState(() {
        societyUserId = societyId;
        towerId = tower;
        flat = flatNumber;
      });
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
                offset: const Offset(0, 3),
                blurRadius: 7,
                spreadRadius: 5,
              )
            ],
          ),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Notices",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: (societyUserId != null && towerId != null && flat != null)
              ? FirebaseFirestore.instance
              .collection("notices")
              .where("society", isEqualTo: societyUserId)
              .where("towerId", isEqualTo: towerId)
              .where("flat", isEqualTo: flat)
              .snapshots()
              : const Stream.empty(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No data", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final notice = docs[index];
                  final noticeTitle = notice["title"];
                  final noticeDescription = notice["notice"];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticeScreen(
                                title: noticeTitle,
                                description: noticeDescription,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          noticeTitle,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          noticeDescription,
                          maxLines: 1,
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
