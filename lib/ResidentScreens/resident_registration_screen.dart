import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../Widgets/dialogue_box.dart';

class ResidentRegistration extends StatefulWidget {
  const ResidentRegistration({super.key});
  @override
  State<ResidentRegistration> createState() => _ResidentRegistrationState();
}

class _ResidentRegistrationState extends State<ResidentRegistration> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _aadharController = TextEditingController();
  var _tower;
  var _flat;
  var _societies;
  File? profilePic;
  List towersList = [
  ];

  List flatsList = [

  ];
  List societies = [];
   @override
  void initState(){
     init();
     super.initState();
  }
  void init(){
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _occupationController = TextEditingController();
    _aadharController = TextEditingController();
    _tower = null;
    _flat = null;
    _societies = null;
    profilePic = null;
    towersList = [
    ];

    flatsList = [

    ];
    societies = [];
    FirebaseFirestore.instance.collection("Society").get().then((value){
      societies = value.docs.map((doc) => {"name": doc.data()["SocietyName"], "number": doc.data()["SocietyTowers"], "id":doc.data()["adminId"]}).toList();
      setState(() {

      });

    });
  }
  void saveData() async {
    String name = _nameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String occupation = _occupationController.text.trim();
    String society = _societies["id"];
    String tower = _tower["id"];
    String towerName = _tower["name"];
    String flat = _flat;
    String aadharNumber = _aadharController.text.trim();

    if (name.isEmpty ||
        phoneNumber.isEmpty ||
        occupation.isEmpty ||
        society.isEmpty ||
        tower.isEmpty ||
        flat.isEmpty ||
        aadharNumber.isEmpty ||
        profilePic == null) {
      DialogBox.showDialogBox(context, "Please Fill all the Details");
      return;
    }

    try {
      EasyLoading.show();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("VisitorProfilePicture")
          .child(Uuid().v1())
          .putFile(profilePic!);

      StreamSubscription taskSubscription =
      uploadTask.snapshotEvents.listen((snapshot) {
        double percentage =
            snapshot.bytesTransferred / snapshot.totalBytes * 100;
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      taskSubscription.cancel();

      await FirebaseFirestore.instance.collection("resident").add({
        "name": name,
        "contactNumber": phoneNumber,
        "occupation": occupation,
        "aadhar": aadharNumber,
        "society": society,
        "flat": flat,
        "tower": tower,
        "profilepic": downloadUrl,
        "type" : 1,
        "towerName":towerName,
        "isAccepted":false,
        "isRejected":false,
      });

      setState(() {
        profilePic = null;
      });
      DialogBox.showDialogBox(context, "Successfully Sent");
      EasyLoading.dismiss();
    } catch (e) {
      DialogBox.showDialogBox(context, "Failed to upload data");
    }

    init();
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
                color: Colors.grey.withOpacity(0.5),
              ),
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
                        border: Border.all(width: 0.5, color: Colors.black),
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (profilePic!= null)? FileImage(profilePic!): const AssetImage("assets/Man.png") as ImageProvider,
                      ),
                    ),
                    Positioned(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              height: 100,
                              margin: EdgeInsets.only(
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
                                        return null;
                                      }
                                    },
                                    leading: Icon(Icons.photo_library_outlined),
                                    title: Text("Gallery"),
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
                                        return null;
                                      }
                                    },
                                    leading: Icon(Icons.photo_camera_outlined),
                                    title: Text("Camera"),
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
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      top: 72,
                      left: 72,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.people),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
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
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Contact Number",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _occupationController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.work),
                    labelText: "Occupation",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
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
                    prefixIcon: Icon(Icons.credit_card_rounded),
                    labelText: "Aadhar Number",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.deepPurple,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton(
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    menuMaxHeight: 200,
                    hint: const Text("Society"),
                    value: _societies,
                    onChanged: (newValue) async{
                      EasyLoading.show();
                      Map value = newValue as Map;
                      towersList = [];
                      for(int i=1; i <= int.parse( value["number"]); i++) {
                        try {
                          DocumentSnapshot query = await FirebaseFirestore
                              .instance.collection("Towers").doc(value["id"] + i
                              .toString()).get();
                          if (query.exists && query.data() != null) {
                             Map data = query.data() as Map;
                            towersList.add({
                              "id": value["id"] + i
                                  .toString(),
                              "name":data["TowerName"]});

                          }
                        } catch (e) {}
                      }
                     setState(() {
                        _societies = newValue;
                        EasyLoading.dismiss();
                      });
                    },
                    items: societies.map(
                      (dynamic e) => DropdownMenuItem(
                        value:  e,
                        child: Text(e["name"]),
                      ) ,
                    ).toList()
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton(
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      menuMaxHeight: 200,
                      hint: const Text("Towers"),
                      value: _tower, // default selected item is null
                      onChanged: (newValue) async{
                        EasyLoading.show();
                        QuerySnapshot querySnapshot= await FirebaseFirestore.instance.collection("Towers").doc((newValue as Map)["id"]).collection("Flats").get();  //doubt
                        flatsList=[];
                        for(int i =0; i< querySnapshot.docs.length; i++){
                          QueryDocumentSnapshot doc = querySnapshot.docs[i];
                          flatsList.add((doc.data() as Map)["flatNumber"]);
                        }

                        setState(() {
                          _tower = newValue; //selected item is passed into a variable and rebuilt the Widget
                        });
                        EasyLoading.dismiss();
                      },
                      items: towersList
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e["name"]),
                              ))
                          .toList(),
                    ),
                    DropdownButton(
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      menuMaxHeight: 200,
                      hint: const Text("Flats"),
                      value: _flat,
                      onChanged: (newValue) {
                        setState(() {
                          _flat = newValue;
                        });
                      },
                      items: flatsList
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    saveData();
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ));
  }
}
