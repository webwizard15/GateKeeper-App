import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../Widgets/dialogue_box.dart';

class EmployeeForm extends StatefulWidget {
  const EmployeeForm({super.key});
  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final List<String> items1 = ["Active", "Inactive"];
  final List<String> items2 = [
    "Guard",
    "Gardner",
    "Maintenance",
    "Cleaner",
    "Others"
  ];
  String selectedValue2 = "Guard";
  String selectedValue = "Active";
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  File? profilepic;  // to save proile picture

  void saveData() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();
    String aadhar = _aadharController.text.trim();
    String status = selectedValue;
    String occupation = selectedValue2;
    _aadharController.clear();
    _nameController.clear();
    _phoneController.clear();
    File? photo = profilepic;

    if (name.isEmpty || phone.isEmpty || aadhar.isEmpty || photo==null) {
      DialogBox.showDialogBox(context, "Please fill all the details");
    } else {
     UploadTask uploadTask = FirebaseStorage.instance.ref().child("profilePictures").child(Uuid().v1()).putFile(profilepic!);
     TaskSnapshot taskSnapshot= await uploadTask;
     String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance.collection("employee").add({
        "name": name,
        "contact number": phone,
        "aadhar number": aadhar,
        "Status": status,
        "occupation": occupation,
        "profile picture": downloadUrl,
      });
      DialogBox.showDialogBox(context, "Successfully Created");
    }
    setState(() {
      profilepic =null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3)),
            ],
          ),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 10, 0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilepic = convertedFile;
                    });
                  } else {
                        DialogBox.showDialogBox(context, "No Image is Selected");
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profilepic!= null? FileImage(profilepic!) : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                keyboardType: TextInputType.phone,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _aadharController,
                decoration: InputDecoration(
                  labelText: "Aadhar Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Police Verification Document",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
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
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: items1
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: e == "Active"
                                      ? const TextStyle(color: Colors.green)
                                      : const TextStyle(color: Colors.red)),
                            ),
                          )
                          .toList()),
                  DropdownButton(
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      menuMaxHeight: 150,
                      value: selectedValue2,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue2 = newValue!;
                        });
                      },
                      items: items2
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList())
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
                onPressed: () {
                  saveData();
                },
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
