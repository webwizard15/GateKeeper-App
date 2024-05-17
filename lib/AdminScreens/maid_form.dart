
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MaidForm extends StatefulWidget {
  const MaidForm({super.key});
  @override
  State<MaidForm> createState() => _MaidFormState();
}

class _MaidFormState extends State<MaidForm> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  File? profilePic;
  var _towers;
  var _flats;
  List towersList =[];
  List flatList =[];

  void saveData()async{
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String address = _addressController.text.trim();
    String aadhar = _aadharController.text.trim();
    var tower = _towers;
    var flat = _flats;
    String? userId = (await SharedPreferences.getInstance()).getString("userId");
    if(name.isEmpty || phone.isEmpty || address.isEmpty || aadhar.isEmpty || tower ==null || flat == null || profilePic == null){
      DialogBox.showDialogBox(context,"Please Fill all the Details");
      return;
    }
    try{
      EasyLoading.show();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("VisitorProfilePicture").child(const Uuid().v1()).putFile(profilePic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("Maids").doc().set({
        "name" : name,
        "contactNumber": phone,
        "address": address,
        "aadhar": aadhar,
        "SocietyId": userId,
        "flatNumber" :flat,
        "tower" : tower,
        "profilePic": downloadUrl,
        "isEntry" : false,
      });
      setState(() {
        _aadharController.clear();
        _nameController.clear();
        _phoneController.clear();
        profilePic = null;
        _addressController.clear();
        _towers= null;
        _flats = null;
      });
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context,"Successfully Added");

    } catch(e){
      DialogBox.showDialogBox(context, "Failed to upload data");
    }

  }
  @override
  void initState(){
    _initializeData();
    super.initState();
  }
  void _initializeData()async{
    String? userId= (await SharedPreferences.getInstance()).getString("userId");
        DocumentSnapshot document= await FirebaseFirestore.instance.collection("Society").doc(userId).get();
       int totalTower = int.parse(document.get("SocietyTowers"));
       List fetchedTowerList = [];
        for(int index=1; index <= totalTower; index++){
            DocumentSnapshot towerDocument = await FirebaseFirestore.instance.collection("Towers").doc(userId! + (index).toString()).get();
            if(towerDocument.exists){
              String towerName = towerDocument.get("TowerName");
              fetchedTowerList.add({
                "name" : towerName,
                "id" : userId + (index).toString(),
              });
            }
        }
        setState(() {
          towersList = fetchedTowerList;
        });
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
                      backgroundImage:(profilePic!= null)? FileImage(profilePic!): const AssetImage("assets/Maid.png") as ImageProvider
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton(
                    menuMaxHeight: 200,
                    underline: Container(
                        height: 2, color: Colors.grey.withOpacity(0.5)),
                    hint: const Text("Towers"),
                    value: _towers,
                    onChanged: (newValue) async {
                      EasyLoading.show();
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection("Towers")
                          .doc((newValue as Map)["id"])
                          .collection("Flats")
                          .get();
                      flatList = [];
                      for (int i = 0; i < querySnapshot.docs.length; i++) {
                        QueryDocumentSnapshot doc = querySnapshot.docs[i];
                        flatList.add((doc.data() as Map)['flatNumber']);
                      }

                      setState(() {
                        _towers = newValue;
                        // flatList = flatNumbers;
                        // _flats = newValue;
                      });
                      EasyLoading.dismiss();
                    },
                    items: towersList
                        .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e["name"])))
                        .toList(),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                    menuMaxHeight: 200,
                    underline: Container(
                        height: 2, color: Colors.grey.withOpacity(0.5)),
                    hint: const Text("Flats"),
                    value: _flats,
                    onChanged: (newValue) async {
                      setState(() {
                        _flats = newValue;
                      });

                    },
                    items: flatList
                        .map((e) => DropdownMenuItem(value: e, child:Text(e)))
                        .toList(),
                  ),
                ],
              ),
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
