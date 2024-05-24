import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:gate_keeper_app/GuardScreens/residents_flats.dart";
import "package:shared_preferences/shared_preferences.dart";

class ResidentTower extends StatefulWidget {
  const ResidentTower({super.key});

  @override
  State<ResidentTower> createState() => _ResidentTowerState();
}

class _ResidentTowerState extends State<ResidentTower> {
  String? societyId;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    String? societyUserId = (await SharedPreferences.getInstance()).getString("society");
    setState(() {
      societyId = societyUserId;
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
            title: const Text("Towers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
        child: societyId == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Towers").where("societyId", isEqualTo: societyId).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  String towerName = docs[index]["TowerName"];
                  String towerId = docs[index].id;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                        backgroundColor: MaterialStateProperty.all(Colors.grey)
                      ),
                      onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => ResidentFlats(towerId: towerId,),));
                      },
                      child: Text(towerName, style: const TextStyle(color: Colors.white),),
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
