
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});
  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  File? profilePic;


  void saveData()async{
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String aadhar = _aadharController.text.trim();
    String? userId = (await SharedPreferences.getInstance()).getString("userId");
    if(name.isEmpty || phone.isEmpty || address.isEmpty || aadhar.isEmpty  || profilePic == null){
      DialogBox.showDialogBox(context,"Please Fill all the Details");
      return;
    }
    try{
      EasyLoading.show();
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: "$aadhar@gmail.com", password: phone);
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("VisitorProfilePicture").child(const Uuid().v1()).putFile(profilePic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("Guards").doc().set({
        "name" : name,
        "contactNumber": phone,
        "address": address,
        "aadhar": aadhar,
        "SocietyId": userId,
        "profilePic": downloadUrl,
        "type": 2,
      });
      setState(() {
        _aadharController.clear();
        _nameController.clear();
        _phoneController.clear();
        profilePic = null;
        _addressController.clear();
      });
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context,"Successfully Added");

    } catch(e){
        EasyLoading.dismiss();
      DialogBox.showDialogBox(context, "Failed to upload data");
    }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: CircleAvatar(
                        radius: 50,
                        backgroundImage:(profilePic!= null)? FileImage(profilePic!): const AssetImage("assets/Guard.png") as ImageProvider
                    ),
                  ),
                  Positioned(
                    left: 72,
                    top: 72,
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              height: 100,
                              margin:const  EdgeInsets.only(
                                  top:20,
                                  bottom: 20
                              ),
                              child: ListView(
                                children: [
                                  ListTile(
                                    onTap: ()async{
                                      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if(selectedImage!=null){
                                        File convertedFile = File(selectedImage.path);
                                        setState(() {
                                          profilePic = convertedFile;
                                        });
                                        Navigator.pop(context);
                                      } else{
                                        Navigator.pop(context);
                                        return ;
                                      }
                                    },
                                    leading: const Icon(Icons.photo_library_outlined),
                                    title:const  Text("Gallery"),
                                  ),
                                  ListTile(
                                    title: const Text("Camera"),
                                    leading: const Icon(Icons.camera_alt_outlined),
                                    onTap: ()async{
                                      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                                      if(selectedImage!=null){
                                        File convertedFile = File(selectedImage.path);
                                        setState(() {
                                          profilePic = convertedFile;
                                        });
                                        Navigator.pop(context);
                                      } else{
                                        Navigator.pop(context);
                                        return;
                                      }
                                    },
                                  )

                                ],
                              ),
                            )
                        );
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _aadharController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.credit_card_rounded),
                  labelText: "Aadhar Number",
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 30,),
              ElevatedButton(
                  onPressed: (){
                    saveData();
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
