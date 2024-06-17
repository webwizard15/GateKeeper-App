import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'complaint_screen.dart';

class ComplaintsLog extends StatefulWidget {
  const ComplaintsLog({super.key});

  @override
  State<ComplaintsLog> createState() => _ComplaintsLogState();
}

class _ComplaintsLogState extends State<ComplaintsLog> {
  int myIndex = 0;
  String? societyId;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  void initializeData() async {
    String? userSocietyId = (await SharedPreferences.getInstance()).getString("userId");
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Closed',
          ),
        ],
      ),
      body: myIndex == 0
          ? buildComplaintList(false)
          : buildComplaintList(true),
    );
  }

  Widget buildComplaintList(bool isClosed) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("complaints")
          .where("society", isEqualTo: societyId)
          .where("isClosed", isEqualTo: isClosed)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available'));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final docs = snapshot.data?.docs;
          return ListView.builder(
            itemCount: docs?.length,
            itemBuilder: (context, index) {
              String complaintTitle = docs?[index]["title"];
              String flatNumber = docs?[index]["flat"];
              String towerName = docs?[index]["towerName"];
              String image = docs?[index]["complaintImage"];
              String complaint = docs?[index]["complaint"];
              String? complaintId = docs?[index].id;
              Timestamp timestamp = docs?[index]["timestamp"];
              DateTime date = timestamp.toDate();
              String formattedDate = DateFormat('dd MMM yyyy').format(date);
              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Material(
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminComplaintScreen(
                            title: complaintTitle,
                            description: complaint,
                            photo: image,
                            id: complaintId,
                          ),
                        ),
                      );
                    },
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaintTitle,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(towerName),
                            Text(flatNumber),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 5,),
                            Text(
                              formattedDate,
                              style: const TextStyle(color: Colors.black, fontSize: 10),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
