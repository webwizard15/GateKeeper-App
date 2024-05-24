import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Widgets/dialogue_box.dart';

class VisitorForm extends StatefulWidget {
  const VisitorForm({super.key});
  @override
  State<VisitorForm> createState() => _VisitorFormState();
}

class _VisitorFormState extends State<VisitorForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();
  var _towers;
  var _flats;
  File? profilePic;
  List towersList =[];
  List flatList =[];

  void saveData()async{
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String purpose = _purposeController.text.trim();
    var tower = _towers;
    var flat = _flats;
    String? userId = (await SharedPreferences.getInstance()).getString("society");
    if(name.isEmpty || phone.isEmpty || tower ==null || flat == null || profilePic == null){
      DialogBox.showDialogBox(context,"Please Fill all the Details");
      return;
    }
    try{
      EasyLoading.show();
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("VisitorProfilePicture").child(const Uuid().v1()).putFile(profilePic!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("Visitors").doc().set({
        "name" : name,
        "contactNumber": phone,
        "purpose":purpose,
        "SocietyId": userId,
        "flatNumber" :flat,
        "towerId" : tower["id"],
        "towerName": tower["name"],
        "profilePic": downloadUrl,
        "status" : "Pending"
      });
      setState(() {
        _nameController.clear();
        _phoneController.clear();
        _purposeController.clear();
        profilePic = null;
        _towers= null;
        _flats = null;
      });
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context,"Request Sent");

    } catch(e){
      DialogBox.showDialogBox(context, "Failed to upload data");
      EasyLoading.dismiss();
    }

  }

  @override
  void initState(){
    _initializeData();
    super.initState();
  }
  void _initializeData()async{
    String? userId= (await SharedPreferences.getInstance()).getString("society");
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
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Border color
                        width: 0.5, // Border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: (profilePic!= null)? FileImage(profilePic!): const AssetImage("assets/Man.png") as ImageProvider,
                      //assets image returns assets image object which is subtype  of ImageProvider<Object>, but the backgroundImage property of CircleAvatar expected an ImageProvider<Object>? type.
                    ),
                  ),
                  Positioned(
                      top: 72,
                      left: 72,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                margin:const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20
                                ),
                                child: ListView(
                                  children: [
                                    ListTile(
                                      onTap: ()async{
                                       XFile? selectedImage= await ImagePicker().pickImage(source: ImageSource.gallery);
                                       if(selectedImage!= null){
                                         File convertedFile= File(selectedImage.path);
                                         setState(() {
                                           profilePic = convertedFile;
                                         });
                                         Navigator.pop(context);
                                       } else {
                                         Navigator.pop(context);
                                         return;
                                       }
                                      },
                                      leading: const Icon(Icons.photo_library_outlined),
                                      title: const Text("Gallery"),
                                    ),
                                    ListTile(
                                      onTap: ()async{
                                       XFile? selectedImage= await ImagePicker().pickImage(source: ImageSource.camera);
                                       if(selectedImage!= null){
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
                                      leading: const Icon(Icons.photo_camera_outlined),
                                      title: const Text("Camera"),
                                    ),
                                  ],
                                ),
                              ),
                          );
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ))
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                      10), //limiting the length to 10 numbers only.
                ],
                controller: _phoneController,
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    prefixIcon: const Icon(Icons.phone),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.deepPurple,
                          width: 2,
                        ))),
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(
                    hintText: "Purpose of Visit",
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.deepPurple,
                        ))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
                  onPressed: () {
                    saveData();
                  },
                  child: const Text("Submit"))
            ],
          ),
        ));
  }
}
