import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  List towersList = [
    "Tower 1",
    "Tower 2",
    "Tower 3",
    "Tower 4",
    "Tower 5",
    "Tower 6",
  ];
  List flatsList = [
    "FLat 101",
    "FLat 102 ",
    "FLat 103",
    "FLat 104",
    "FLat 105",
    "FLat 106",
    "FLat 107",
    "FLat 108"
  ];
  void saveData() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String purpose = _purposeController.text.trim();
    var towers = _towers;
    var flats = _flats;


    if (name.isEmpty ||
        phone.isEmpty ||
        purpose.isEmpty ||
        towers == null ||
        flats == null ||
        profilePic ==null
    ) {
      DialogBox.showDialogBox(context, "Please Fill all the Details");
    }
    else {
     UploadTask uploadTask= FirebaseStorage.instance.ref().child("VisitorProfilePicture").child( Uuid().v1()).putFile(profilePic!);
      StreamSubscription taskSubscription = uploadTask.snapshotEvents.listen((snapshot) {
       double percentage = snapshot.bytesTransferred/ snapshot.totalBytes *100;
     });


     TaskSnapshot taskSnapshot= await uploadTask;  // we get the task snapshot once uploading is finished.
     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
     taskSubscription.cancel();

      await FirebaseFirestore.instance.collection("visitors").add({
        "name": name,
        "contact Number": phone,
        "purpose": purpose,
        "flats": flats,
        "towers": towers,
        "profilepic": downloadUrl,
      });
      setState(() {
        profilePic=null;
      });
      DialogBox.showDialogBox(context, "Successfully Sent");
    }
    _nameController.clear();
    _phoneController.clear();
    _purposeController.clear();
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
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      top: 72,
                      left: 72)
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
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    menuMaxHeight: 200,
                    hint: const Text("Towers"),
                    value: _towers, // default selected item is null
                    onChanged: (newValue) {
                      setState(() {
                        _towers =
                            newValue; //selected item is passed into a variable and rebuilt the Widget
                      });
                    },
                    items: towersList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
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
                    value: _flats,
                    onChanged: (newValue) {
                      setState(() {
                        _flats = newValue;
                      });
                    },
                    items: flatsList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                  )
                  // DropdownButton(
                  //
                  // ),
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
