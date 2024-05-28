import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/admin_menu_screen.dart';
import 'package:gate_keeper_app/AdminScreens/registration.dart';
import 'package:gate_keeper_app/AdminScreens/tower_updation.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TowersConfigurationScreen extends StatefulWidget {
  const TowersConfigurationScreen({super.key});

  @override
  State <TowersConfigurationScreen> createState() => _TowerConfigurationState();
}

class _TowerConfigurationState extends State<TowersConfigurationScreen> {
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
            centerTitle: true,
            title: const Text(
              "Set-up Towers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, shared) {
            if (shared.hasData) {
              String userId = (shared.data!).getString("userId")!;
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("Society")
                    .doc(userId)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data() == null) {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                  else {
                    final towers = int.parse(snapshot.data!.data()!["SocietyTowers"]);
                    return ListView.builder(
                      itemCount: towers,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Towers")
                              .doc(userId + (index + 1).toString())
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data != null &&
                                snapshot.data!.data() != null) {
                              Map data = snapshot.data!.data()! as Map;
                              return ElevatedButton(
                                onPressed: () {
                                  DialogBox.showDialogBox(context, "Tower Already Configured", isEdit: true, userId: userId+(index +1).toString(), name:data['TowerName'] );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: Container(
                                    width: 100,
                                    height: 60,
                                    child:
                                        Center(child: Text(data['TowerName']))),
                              );
                            }
                            return ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TowerUpdationScreen(
                                          towerNumber: (index + 1))),
                                );
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Container(
                                  width: 100,
                                  height: 60,
                                  child: Center(
                                      child: Text("Tower ${index + 1}"))),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              );
            }
            return const CircularProgressIndicator();
          }),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(bottom: 10, right: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton(
                onPressed: () async {
                  try {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Caution"),
                        content: const Text(
                          "You may loose whole society set up.",
                          style: TextStyle(fontSize: 18),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              String? userId = (await SharedPreferences.getInstance()).getString("userId");
                              DocumentSnapshot documentSnapshot =await FirebaseFirestore.instance.collection("Society").doc(userId).get();
                                Map? data = documentSnapshot.data() as Map<String, dynamic>;
                                int totalTowers = int.parse(data["SocietyTowers"]);
                                for(int index=1; index <= totalTowers; index++){

                                  await FirebaseFirestore.instance.collection("Towers").doc(userId! + (index).toString())
                                      .collection("Flats").doc().delete();
                                  await FirebaseFirestore.instance
                                      .collection("Towers")
                                      .doc(userId + (index).toString())
                                      .delete();
                                }

                              await FirebaseFirestore.instance
                                  .collection("Society")
                                  .doc(userId)
                                  .delete();

                              Navigator.popUntil(context, (route) => false);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminMenuScreen(),));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SocietyRegistration(),
                                  ));
                            },
                            child: const Text("Delete"),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Deny"))
                        ],
                      ),
                    );
                  } catch (e) {
                    DialogBox.showDialogBox(context, "$e");
                  }
                },
                backgroundColor: Colors.white,
                child: const Icon(Icons.delete),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
