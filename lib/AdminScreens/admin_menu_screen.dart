import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/AdminScreens/registration.dart';
import 'package:gate_keeper_app/AdminScreens/resident_approval.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../Widgets/dialogue_box.dart';
import '../screens/menu_screen.dart';
import 'admin_sign_in_screen.dart';
import 'complain_list.dart';
import 'guard_list.dart';
import 'maid_list.dart';
import 'notice_screen.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  String? adminName;
  File? profilePic;
  String? userId;
  String? profilePhoto;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  void _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? adminUserId = prefs.getString("userId");
    if (adminUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(adminUserId)
          .get();
      if (doc.exists) {
        String? name = doc["name"];
        String? picture = doc["profilePicture"];
        setState(() {
          adminName = name;
          profilePhoto = picture;
          userId = adminUserId;
        });
      }
    }
  }

  Future<void> _uploadProfilePicture(File imageFile) async {
    try {
      EasyLoading.show();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("AdminProfilePictures")
          .child(const Uuid().v1())
          .putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(userId)
          .update({"profilePicture": downloadUrl});
      setState(() {
        profilePhoto = downloadUrl;
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context, "Unable to upload image");
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      await _uploadProfilePicture(convertedFile);
    }
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
                blurRadius: 7,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            title: const Text(
              "Management Portal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(10),
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
                        child: profilePhoto != null
                            ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profilePhoto!),
                        )
                            : const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/Man.png"),
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
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  bottom: 20,
                                ),
                                child: ListView(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        await _selectImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                      leading: const Icon(Icons.photo_library_outlined),
                                      title: const Text("Gallery"),
                                    ),
                                    ListTile(
                                      title: const Text("Camera"),
                                      leading: const Icon(Icons.camera_alt_outlined),
                                      onTap: () async {
                                        await _selectImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: adminName != null
                        ? Text(
                      adminName!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const Text(
                      "Admin",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note_outlined, size: 25),
              title: const Text(
                "Notice",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Notice(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_work_outlined, size: 25),
              title: const Text(
                "Towers/Flats",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SocietyRegistration(),
                    ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, size: 25),
              title: const Text(
                "Log Out",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              onTap: () async {
                SharedPreferences shared =
                await SharedPreferences.getInstance();
                shared.clear(); // it will clear the id
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(
                    context, (route) => false); // it will clear the stack.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MenuScreen()));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminSignInScreen(),
                    ));
              },
            ),
            const Divider(
              thickness: 2,
              indent: 8,
              endIndent: 8,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddEmployee(),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Guard.png"),
                        fit: BoxFit.contain, // Use BoxFit.contain or BoxFit.scaleDown
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Guards",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResidentApprovalScreen(),
                        ));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Resident.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Resident",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MaidListScreen(),
                        ));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Maid.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Maid",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ComplaintsLog(),
                        ));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Report.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Complaints",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
