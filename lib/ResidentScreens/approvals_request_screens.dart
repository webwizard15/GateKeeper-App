import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart.';
import 'package:flutter/widgets.dart';

class RequestApprovalScreen extends StatefulWidget {
  const RequestApprovalScreen({super.key});
  @override
  State<RequestApprovalScreen> createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 7,
                  spreadRadius: 5,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: AppBar(
              centerTitle: true,
              title: Text(
                "Approvals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("visitors").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                final visitors = snapshot.data!.docs.reversed.toList();
                return ListView.builder(
                  itemCount: visitors.length,
                  itemBuilder: (context, index) {
                    var visitor = visitors[index];
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
                                    NetworkImage(visitor["profilepic"]),
                              ),
                              title: Text(
                                visitor["name"],
                                style: TextStyle(fontWeight: FontWeight.w500,  fontSize:18),
                              ),
                              subtitle: Text(visitor["purpose"], style: TextStyle(fontSize: 15),),
                              trailing: IconButton(
                                onPressed: (){},
                                icon: Icon(Icons.phone),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left:30, right: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        shape:MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
                                        backgroundColor: MaterialStateProperty.all(Colors.green),
                                      ),
                                      onPressed: () {

                                      },
                                      child: Text(
                                        "APPROVE",
                                        style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: OutlinedButton(
                                      style:ButtonStyle(
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),),
                                          backgroundColor: MaterialStateProperty.all(Colors.red)
                                      ),
                                      onPressed: () {},

                                      child: Text(
                                        "DENY",
                                        style: TextStyle(color: Colors.white,

                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Text("NO data Now");
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
