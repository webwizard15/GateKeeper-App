
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/maid_form.dart';
import 'package:gate_keeper_app/AdminScreens/maid_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaidListScreen extends StatefulWidget {
  const MaidListScreen({super.key});
  @override
  State<MaidListScreen> createState() => _MaidListScreenState();
}

class _MaidListScreenState extends State<MaidListScreen> {
  String? societyUserId;
  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    String? userId =
        (await SharedPreferences.getInstance()).getString("userId");
    societyUserId = userId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
                color: Colors.grey.withOpacity(0.5))
          ]),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MaidForm()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Maids")
                .where("SocietyId", isEqualTo: societyUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                    child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(child: Text("No Data Available")),
                ));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Container(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width,
                      child: const Center(child: CircularProgressIndicator())),
                );
              } else if (snapshot.hasError) {
                return Expanded(
                    child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Center(child: Text('Error: ${snapshot.error}')),
                ));
              } else {
                final docs = snapshot.data?.docs.toList();
                return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    String name = docs?[index]["name"];
                    String phoneNumber = docs?[index]["contactNumber"];
                    String flatNumber = docs?[index]["flatNumber"];
                    String towerName = docs?[index]["tower"]["name"];
                    String profilePic = docs?[index]["profilePic"];
                    String? maidId= docs?[index].id;
                    String aadharNumber = docs?[index]["aadhar"];
                    String address = docs?[index]["address"];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5,
                        child: ListTile(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MaidProfile(name: name,
                            phoneNumber: phoneNumber, aadharNumber: aadharNumber,address:address,profilePicture: profilePic,maidId: maidId,
                            ),
                            ),
                            );
                          },
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(profilePic),
                          ),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(phoneNumber, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15,)),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                towerName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent),
                              ),
                              Text(flatNumber,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}
