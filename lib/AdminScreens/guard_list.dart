import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/employee_form_screen.dart';
import 'package:gate_keeper_app/AdminScreens/guard_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  String? societyUserId;
 @override
  void initState() {
   initializeData();
    super.initState();
  }
  void initializeData()async{
   String? userId = (await SharedPreferences.getInstance()).getString("userId");
   setState(() {
     societyUserId = userId;
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeForm(),
            ),
          );
        },
        child:const  Icon(Icons.add),
      ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.2),
                hintText: "search..",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: (value) {
                // Implement your search logic here
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Guards").where("SocietyId", isEqualTo:societyUserId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final guards = snapshot.data!.docs.toList();
                    return ListView.builder(
                      itemCount: guards.length,
                      itemBuilder: (context, index) {
                        var guard = guards[index];
                       String guardId = guards[index].id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            elevation:5,
                            child: ListTile(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => GuardProfile(name: guard["name"], phoneNumber: guard["contactNumber"], address: guard["address"], profilePicture: guard["profilePic"], aadharNumber: guard["aadhar"], guardId: guardId),));
                              },
                              title: Text(guard["name"], style: const TextStyle(fontWeight: FontWeight.bold),),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(guard["profilePic"]),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.phone, size: 15,),
                                  const SizedBox(width: 5,),
                                  Text(guard["contactNumber"],style: const TextStyle(fontSize: 15),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
