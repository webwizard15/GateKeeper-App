import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _titleController = TextEditingController();
  final _complaintFieldController = TextEditingController();
  String? flat;
  String? tower;
  File? profilePic;

  void saveData() async {
    String title = _titleController.text.trim();
    String complaint = _complaintFieldController.text.trim();

    String? societyId = (await SharedPreferences.getInstance()).getString("society");

    if (title.isEmpty || complaint.isEmpty) {
      DialogBox.showDialogBox(context, "Please fill all the details");
      return;
    } else {
      try {
        EasyLoading.show();
        String? downloadUrl;
        if (profilePic != null) {
          UploadTask uploadTask = FirebaseStorage.instance
              .ref()
              .child("VisitorProfilePicture")
              .child(const Uuid().v1())
              .putFile(profilePic!);

          StreamSubscription taskSubscription =
          uploadTask.snapshotEvents.listen((snapshot) {
            double percentage = snapshot.bytesTransferred / snapshot.totalBytes * 100;
            EasyLoading.showProgress(percentage / 100, status: 'Uploading...');
          });

          TaskSnapshot taskSnapshot = await uploadTask;
          downloadUrl = await taskSnapshot.ref.getDownloadURL();
          taskSubscription.cancel();
        }

        await FirebaseFirestore.instance.collection("complaints").doc().set({
          "title": title,
          "complaint": complaint,
          "towerName": tower,
          "flat": flat,
          "society": societyId,
          "complaintImage": downloadUrl,
          "isClosed": false,
        });
        EasyLoading.dismiss();
        DialogBox.showDialogBox(context, "Sent");
        _complaintFieldController.clear();
        _titleController.clear();
        setState(() {
          profilePic = null;
        });
      } catch (e) {
        EasyLoading.dismiss();
        DialogBox.showDialogBox(context, "Error occurred: $e");
      }
    }
  }

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    String? userId = (await SharedPreferences.getInstance()).getString("userId");
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("resident")
        .doc(userId)
        .get();
    String flatNumber = documentSnapshot.get("flat");
    String towerName = documentSnapshot.get("towerName");
    setState(() {
      flat = flatNumber;
      tower = towerName;
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
                spreadRadius: 5,
                blurRadius: 7,
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Complaint",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(15, 40, 15, 40),
        padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black,
            width: 2,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 10,
                controller: _complaintFieldController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (profilePic != null)
                Image.file(
                  profilePic!,
                  height: 200,
                )
              else
                const Text("No image selected"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Additional Information"),
                  IconButton(
                    onPressed: () {
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
                                    File convertedFile = File(selectedImage.path);
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
                                onTap: () async {
                                  XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.camera);
                                  if (selectedImage != null) {
                                    File convertedFile = File(selectedImage.path);
                                    setState(() {
                                      profilePic = convertedFile;
                                    });
                                    Navigator.pop(context);
                                  } else {
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
                    icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
