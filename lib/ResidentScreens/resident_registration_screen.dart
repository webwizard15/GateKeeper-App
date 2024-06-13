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
import '../Widgets/validations.dart';

class ResidentRegistration extends StatefulWidget {
  const ResidentRegistration({super.key});

  @override
  State<ResidentRegistration> createState() => _ResidentRegistrationState();
}

class _ResidentRegistrationState extends State<ResidentRegistration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();

  Map<String, dynamic>? _selectedSociety;
  Map<String, dynamic>? _selectedTower;
  String? _selectedFlat;
  File? profilePic;
  List<Map<String, dynamic>> towersList = [];
  List<String> flatsList = [];
  List<Map<String, dynamic>> societies = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchSocieties();
  }

  Future<void> _fetchSocieties() async {
    try {
      final value = await FirebaseFirestore.instance.collection("Society").get();
      setState(() {
        societies = value.docs.map((doc) => {
          "name": doc.data()["SocietyName"],
          "number": doc.data()["SocietyTowers"],
          "id": doc.data()["adminId"]
        }).toList();
      });
    } catch (e) {
      DialogBox.showDialogBox(context, "Failed to load societies");
    }
  }

  Future<void> _fetchTowers(Map<String, dynamic> society) async {
    towersList = [];
    for (int i = 1; i <= int.parse(society["number"]); i++) {
      try {
        final query = await FirebaseFirestore.instance
            .collection("Towers")
            .doc(society["id"] + i.toString())
            .get();
        if (query.exists && query.data() != null) {
          Map<String, dynamic> data = query.data() as Map<String, dynamic>;
          towersList.add({"id": society["id"] + i.toString(), "name": data["TowerName"]});
        }
      } catch (e) {
        DialogBox.showDialogBox(context, "Unable to fetch towers data");
      }
    }
  }
  Future<void> _fetchFlats(String towerId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection("Towers")
          .doc(towerId)
          .collection("Flats")
          .get();

      flatsList = querySnapshot.docs
          .map((doc) => (doc.data())["flatNumber"].toString())
          .toList();
    } catch (e) {
      DialogBox.showDialogBox(context, "Unable to fetch flats");
    }
  }

  void _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    if (profilePic == null || _selectedSociety == null || _selectedTower == null || _selectedFlat == null) {
      DialogBox.showDialogBox(context, "Please fill all the details");
      return;
    }

    String name = _nameController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    String occupation = _occupationController.text.trim();
    String societyId = _selectedSociety!["id"];
    String towerId = _selectedTower!["id"];
    String towerName = _selectedTower!["name"];
    String flat = _selectedFlat!;
    String aadharNumber = _aadharController.text.trim();

    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("resident")
        .where('society', isEqualTo: societyId)
        .where('tower', isEqualTo: towerId)
        .where('flat', isEqualTo: flat)
        .get();

    if (documentSnapshot.docs.isNotEmpty) {
      DialogBox.showDialogBox(context, "Resident already occupied.");
      return;
    }

    try {
      EasyLoading.show();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("VisitorProfilePicture")
          .child(const Uuid().v1())
          .putFile(profilePic!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("resident").add({
        "name": name,
        "contactNumber": phoneNumber,
        "occupation": occupation,
        "aadhar": aadharNumber,
        "society": societyId,
        "flat": flat,
        "tower": towerId,
        "profilepic": downloadUrl,
        "type": 1,
        "towerName": towerName,
        "isAccepted": false,
        "isRejected": false,
      });

      setState(() {
        profilePic = null;
        _nameController.clear();
        _phoneController.clear();
        _occupationController.clear();
        _aadharController.clear();
        _selectedSociety = null;
        _selectedTower = null;
        _selectedFlat = null;
        towersList.clear();
        flatsList.clear();
      });

      DialogBox.showDialogBox(context, "Successfully Sent");
    } catch (e) {
      DialogBox.showDialogBox(context, "Failed to upload data");
    } finally {
      EasyLoading.dismiss();
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
              color: Colors.grey.withOpacity(0.5),
            ),
          ]),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text("Registration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Form(
            key: _formKey,
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
                        backgroundImage: profilePic != null
                            ? FileImage(profilePic!)
                            : const AssetImage("assets/Man.png") as ImageProvider,
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
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              child: ListView(
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                                      if (selectedImage != null) {
                                        setState(() {
                                          profilePic = File(selectedImage.path);
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    leading: const Icon(Icons.photo_library_outlined),
                                    title: const Text("Choose from gallery"),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                                      if (selectedImage != null) {
                                        setState(() {
                                          profilePic = File(selectedImage.path);
                                        });
                                      }
                                      Navigator.pop(context);
                                    },
                                    leading: const Icon(Icons.photo_camera_outlined),
                                    title: const Text("Take a picture"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 28,
                          width: 28,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 20,
                            color: Colors.white,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.nameValidation,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: const Icon(Icons.people),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(width: 2, color: Colors.deepPurple),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.phoneValidation,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: "Contact Number",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _occupationController,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.nameValidation,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.work),
                    labelText: "Occupation",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _aadharController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: Validation.aadharValidation,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.credit_card_rounded),
                    labelText: "Aadhar Number",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
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
                  value: _selectedSociety,
                  onChanged: (newValue) async {
                    EasyLoading.show();
                    _selectedSociety = newValue as Map<String, dynamic>;
                    await _fetchTowers(_selectedSociety!);
                    setState(() {});
                    EasyLoading.dismiss();
                  },
                  items: societies
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e["name"]),
                  ))
                      .toList(),
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
                      value: _selectedTower,
                      onChanged: (newValue) async {
                        EasyLoading.show();
                        _selectedTower = newValue as Map<String, dynamic>;
                        await _fetchFlats(_selectedTower!["id"]);
                        setState(() {});
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
                      value: _selectedFlat,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedFlat = newValue;
                        });
                      },
                      items: flatsList
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveData,
                  child: const Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
