import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ResidentMaidsLogs extends StatefulWidget {
  const ResidentMaidsLogs({super.key});

  @override
  State<ResidentMaidsLogs> createState() => _ResidentMaidsLogsState();
}

class _ResidentMaidsLogsState extends State<ResidentMaidsLogs> {
  int myIndex = 0;
  String? societyId;

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
            label: 'Residents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cleaning_services),
            label: 'Maids',
          ),
        ],
      ),
      body: myIndex == 0
          ? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("residentVisit")
            .where("societyId", isEqualTo: societyId)
            .where("isResident", isEqualTo: true)
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
                String residentName = docs?[index]["name"];
                String phoneNumber = docs?[index]["phoneNumber"];
                String flatNumber = docs?[index]["flatNumber"];
                String towerName = docs?[index]["towerName"];
                Timestamp dateTime = docs?[index]["date"];
                bool isExit = docs?[index]["isExit"];
                String? id = docs?[index].id;
                DateTime date = dateTime.toDate();
                String formattedDate = DateFormat('dd-MM-yyyy / hh:mm').format(date);
                return Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Material(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(residentName[0]),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            residentName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Phone :"),
                              GestureDetector(
                                  onTap: (){
                                    final Uri number = Uri.parse("tel:$phoneNumber");
                                    launchUrl(number);
                                  },
                                  child: Text(phoneNumber, style: const TextStyle(color: Colors.blueAccent),)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text('Tower: $towerName'),
                          const SizedBox(height: 5),
                          Text('Flat: $flatNumber'),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 8, color: Colors.green),
                              ),
                              isExit
                                  ? Text(
                                DateFormat('dd-MM-yyyy / hh:mm').format((docs?[index]["exitDate"] as Timestamp).toDate()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 8, color: Colors.red),
                              )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                      trailing: isExit == false
                          ? ElevatedButton(
                        onPressed: () async {
                          DateTime now = DateTime.now();
                          await FirebaseFirestore.instance.collection("residentVisit").doc(id).update({
                            "isExit": true,
                            "exitDate": now,
                          });
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                        child: const Text(
                          "EXIT",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ),
                );
              },
            );
          }
        },
      )
          : StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("residentVisit")
            .where("societyId", isEqualTo: societyId)
            .where("isMaid", isEqualTo: true)
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
                String maidName = docs?[index]["name"];
                String picture = docs?[index]["profilePicture"];
                String maidPhoneNumber = docs?[index]["contactNumber"];
                Timestamp dateTime = docs?[index]["entryDate"];
                DateTime date = dateTime.toDate();
                String formattedDate = DateFormat('dd-MM-yyyy / hh:mm').format(date);
                bool isExit = docs?[index]["isExit"];
                String? id = docs?[index].id;
                return Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Material(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(picture),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            maidName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text("Phone :"),
                              GestureDetector(
                                onTap: (){
                                  final Uri phoneNumber = Uri.parse("tel:$maidPhoneNumber");
                                  launchUrl(phoneNumber);
                                },
                                  child: Text(maidPhoneNumber, style:const  TextStyle(color: Colors.blueAccent),)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 8, color: Colors.green),
                              ),
                              isExit
                                  ? Text(
                                DateFormat('dd-MM-yyyy / hh:mm').format((docs?[index]["exitDate"] as Timestamp).toDate()),
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 8, color: Colors.red),
                              )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                      trailing: isExit == false
                          ? ElevatedButton(
                        onPressed: () async {
                          DateTime now = DateTime.now();
                          await FirebaseFirestore.instance.collection("residentVisit").doc(id).update({
                            "isExit": true,
                            "exitDate": now,
                          });
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                        child: const Text(
                          "EXIT",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                          : const SizedBox.shrink(),
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
