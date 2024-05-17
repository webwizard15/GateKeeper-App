import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MaidProfile extends StatefulWidget{
  final String name;
  final String phoneNumber;
  final String aadharNumber;
  final String profilePicture;
  final String address;
  final String? maidId;
  const MaidProfile({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.profilePicture,
    required this.aadharNumber,
    required this.maidId,
});
  @override
  State<MaidProfile> createState() => _MaidProfileState();
}
class _MaidProfileState extends State<MaidProfile>{
  void deleteProfile()async{
     await FirebaseFirestore.instance.collection("Maids").doc(widget.maidId).delete();

  }
  @override
  Widget build(BuildContext context){
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
        onPressed: (){
           showDialog(context: context, builder:(context) =>AlertDialog(
             title: const Text("Caution"),
             content: const Text("Do you really want to delete the profile"),
             actions:<Widget>[
               TextButton(
                   onPressed: (){
                     deleteProfile();
                     Navigator.pop(context);
               },
                 child:const Text("Yes"),
               ),
               TextButton(
                   onPressed: (){
                     Navigator.pop(context);
               },
                 child:const Text("No"),
               ),

             ],
           ),);
        },
        child: const Icon(Icons.delete),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 15,
          right: 15,
        ),
        child:ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black)
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage:NetworkImage(widget.profilePicture) ,
              ),
            ),
            const SizedBox(height: 20,),
            Center(child: Text(widget.name, style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)),
            const SizedBox(height: 20,),
            Container(
              padding: const EdgeInsets.fromLTRB(10,20,10, 20),
              decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children:[
                      const Text("Contact Number :", style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 15)),
                      const SizedBox(width: 15,),
                      GestureDetector(
                          onTap: ()async{
                            Uri maidNumber = Uri.parse("tel: ${widget.phoneNumber}");
                            await launchUrl(maidNumber);
                          },
                          child: Text(widget.phoneNumber,
                            style: const TextStyle(fontSize: 15,
                                color: Colors.deepPurple,
                              decoration: TextDecoration.underline
                            ),
                          ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(

                    children:[
                      const Text("Address :", style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 15),),
                      const SizedBox(width: 15,),
                      Text(widget.address, style: const TextStyle(fontSize: 15),),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children:[
                      const Text("Addhar Number :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(width: 15,),
                      Text(widget.aadharNumber, style: const TextStyle(fontSize: 15),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}