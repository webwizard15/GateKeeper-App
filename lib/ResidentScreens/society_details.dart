import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocietyDetails extends StatelessWidget {
  const SocietyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: 7,
                blurRadius: 5,
                offset: const Offset(0, 3),
                color: Colors.grey.withOpacity(0.5),
              )
            ],
          ),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder<QuerySnapshot>(
            future:
                FirebaseFirestore.instance.collection("Society").limit(1).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Expanded(
                  child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Expanded(
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height,
                    decoration: const BoxDecoration(
                    ),
                    child:const  Center(child: Text("No Data Available", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
                  ),
                );
              }
              final String societyName =
                  snapshot.data!.docs.first["SocietyName"];
              final String societyAddress =
                  snapshot.data!.docs.first["SocietyAddress"];
              final String societyEmailId =
                  snapshot.data!.docs.first["SocietyEmailID"];
              final String societyTowers =
                  snapshot.data!.docs.first["SocietyTowers"];
              final String state = snapshot.data!.docs.first["State"];
              final String city = snapshot.data!.docs.first["City"];
              final String adminEmailId =
                  snapshot.data!.docs.first["AdminEmailId"];
              final String adminName = snapshot.data!.docs.first["AdminName"];
              final String adminMobileNumber =
                  snapshot.data!.docs.first["AdminMobileNumber"];

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        societyName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){

                        },
                        child: Text(
                          societyEmailId,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                            color: Colors.deepPurple,
                            decoration: TextDecoration.underline
                          ),
                        ),
                      ),
                      Text(
                        "$societyAddress\n$city, $state,",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Administrative Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Icon(Icons.people, size:18,),
                          const SizedBox(width: 10,),
                          Text(
                            adminName,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.email, size:18,),
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () async{
                              Uri adminEmail = Uri.parse("mailto:$adminEmailId");
                              launchUrl(adminEmail);
                            },
                            child: Text(
                              adminEmailId,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                color: Colors.deepPurple,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, size:18,),
                          const SizedBox(width: 10,),
                          GestureDetector(
                            onTap: () async{
                              Uri adminNumber = Uri.parse("tel: $adminMobileNumber");
                              await launchUrl(adminNumber);
                            },
                            child: Text(
                              adminMobileNumber,
                              style:const  TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                color: Colors.deepPurple,
                                decoration: TextDecoration.underline
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Container(
                        height: 200,
                        width: 150,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/Building.png",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
