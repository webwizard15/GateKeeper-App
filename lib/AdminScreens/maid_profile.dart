

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Widgets/dialogue_box.dart';
import '../Widgets/validations.dart';

class MaidProfile extends StatefulWidget{
   String name;
   String phoneNumber;
  final String aadharNumber;
  final String profilePicture;
   String address;
  final String? maidId;
     MaidProfile({
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


  void editDetails(){
    final TextEditingController nameController = TextEditingController(text: widget.name);
    final TextEditingController phoneController = TextEditingController(text: widget.phoneNumber);
    final TextEditingController addressController = TextEditingController(text: widget.address);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    showDialog(context: context,
      builder: (context) => AlertDialog(
        title:const Text("Edit Details"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: Validation.nameValidation,
                decoration: InputDecoration(
                  labelText: "Name",
                  prefixIcon: const Icon(Icons.people),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 2,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: Validation.phoneValidation,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  labelText: "Contact Number",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),
              TextFormField(
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.work),
                  labelText: "Address",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: ()async{
            if (!formKey.currentState!.validate()) return;
            if(nameController.text.isEmpty|| phoneController.text.isEmpty || addressController.text.isEmpty){
              DialogBox.showDialogBox(context, "Please provide the valid details");
            }
            try{
              await FirebaseFirestore.instance.collection("Maids").doc(widget.maidId).update({
                "name": nameController.text.trim(),
                "contactNumber": phoneController.text.trim(),
                "address": addressController.text.trim(),
              });
              setState(() {
                widget.name = nameController.text.trim();
                widget.phoneNumber= phoneController.text.trim();
                widget.address = addressController.text.trim();
              });
              Navigator.pop(context);
            } catch(e){
              DialogBox.showDialogBox(context, e.toString());
            }

          }, child:const Text("SAVE"))
        ],
      ),);
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
                  SizedBox(
                    height: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 5,),
                        IconButton(onPressed: (){
                           editDetails();
                        }, icon:const Icon(Icons.edit, size:15,))
                      ],
                    ),
                  ),
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
                      Flexible(
                        fit: FlexFit.loose,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            widget.address,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    children:[
                      const Text("Aadhaar Number :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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