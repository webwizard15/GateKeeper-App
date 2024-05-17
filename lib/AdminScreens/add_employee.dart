import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/employee_form_screen.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {

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
              stream: FirebaseFirestore.instance.collection("employee").orderBy("Status").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final employees = snapshot.data!.docs.toList();
                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        var employee = employees[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Material(
                            elevation:5,
                            child: ListTile(
                              onTap: (){},
                              title: Text(employee["name"], style: TextStyle(fontWeight: FontWeight.w500),),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(employee["profile picture"]),
                              ),
                              subtitle: Text(employee["occupation"],),
                              trailing: Container(
                                  width: 45,
                                  child: Text(employee["Status"], style: TextStyle(color: employee["Status"]=="Active"? Colors.green: Colors.red,), )),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
