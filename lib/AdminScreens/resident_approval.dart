import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter_easyloading/flutter_easyloading.dart";
import "package:gate_keeper_app/Widgets/dialogue_box.dart";
import "package:shared_preferences/shared_preferences.dart";

class ResidentApprovalScreen extends StatefulWidget {
  const ResidentApprovalScreen({super.key});
  @override
  State<ResidentApprovalScreen> createState() => _ResidentApprovalScreenState();
}

class _ResidentApprovalScreenState extends State<ResidentApprovalScreen> {
  int myIndex = 0;
  String? userId;

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  void getUserId() async {
    userId = (await SharedPreferences.getInstance()).getString("userId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5), boxShadow: [
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Request",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work), label: "Resident")
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("resident")
            .where("society", isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Expanded(
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Center(child: CircularProgressIndicator())),
            );
          } else if (snapshot.hasError) {
            return Expanded(
              child: SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Center(child: Text('Error: ${snapshot.error}'))),
            );
          } else {
            final totalResidents = snapshot.data!.docs.toList();
            if(totalResidents.every((element) =>element["isAccepted"] == true ) && myIndex == 0){
              return Expanded(
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: const Center(child: Text("No Pending Requests..", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),))),
              );
            }
            return ListView.builder(
              itemCount: totalResidents.length,
              itemBuilder: (context, index) {
                final residentData = totalResidents[index].data();
                final residentId = totalResidents[index].id;
                if(residentData["isAccepted"] == true && myIndex == 0 || myIndex==1 && residentData["isAccepted"] != true){
                  return const SizedBox.shrink();
                }
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
                            NetworkImage(residentData["profilepic"]),
                          ),
                          title: Text(
                            residentData["name"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                residentData["contactNumber"],
                              )
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(residentData["towerName"], style:const TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent),),
                              Text(residentData["flat"], style:const TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent))
                            ],
                          ),
                        ),
                        if(myIndex==0)
                          Row(
                            children: [
                              const SizedBox(width: 20,),
                              Expanded(
                                child: OutlinedButton(
                                    onPressed: () async {
                                      await _approveResident(residentId, residentData);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.green),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: const Text("Approve", style: TextStyle(color: Colors.white),)),
                              ),
                              const SizedBox(width: 20,),
                              Expanded(
                                child: OutlinedButton(
                                    onPressed: () async {
                                      await _denyResident(residentId);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    child: const Text("Deny", style: TextStyle(color: Colors.white),)),
                              ),
                              const SizedBox(width: 20,),
                            ],
                          )
                      ],
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

  Future<void> _approveResident(String residentId, Map<String, dynamic> residentData) async {
    try {
      EasyLoading.show();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "${residentData["aadhar"]}@gmail.com", password: residentData["contactNumber"]);
      await FirebaseFirestore.instance.collection("resident").doc(residentId).update({"isAccepted": true});
      EasyLoading.dismiss();
      if (mounted) {
        DialogBox.showDialogBox(context, "User Created Successfully");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        DialogBox.showDialogBox(context, "unable to create credential");
      }
    }
  }

  Future<void> _denyResident(String residentId) async {
    try {
      EasyLoading.show();
      await FirebaseFirestore.instance.collection("resident").doc(residentId).delete();
      EasyLoading.dismiss();
      if (mounted) {
        DialogBox.showDialogBox(context, "User Denied Successfully");
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (mounted) {
        DialogBox.showDialogBox(context, e.toString());
      }
    }
  }
}