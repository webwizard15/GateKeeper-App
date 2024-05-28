import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNotice extends StatefulWidget {
  const AddNotice({super.key});

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  final _titleController = TextEditingController();
  final _noticeFieldController = TextEditingController();
  var _selectedTower;
  var _selectedFlat;

  List<Map<String, String>> towersList = [];
  List<dynamic> flatList = [];

  void saveData() async {
    String title = _titleController.text.trim();
    String notice = _noticeFieldController.text.trim();
    var selectedTower = _selectedTower;
    var selectedFlat = _selectedFlat;
    String? userId = (await SharedPreferences.getInstance()).getString("userId");

    if (title.isEmpty || notice.isEmpty || selectedTower == null || selectedFlat == null) {
      DialogBox.showDialogBox(context, "Please fill all the details");
      return;
    } else {
      try {
        EasyLoading.show();
        await FirebaseFirestore.instance.collection("notices").doc().set({
          "title": title,
          "notice": notice,
          "flat": selectedFlat,
          "towerId": selectedTower['id'],
          "towerName": selectedTower['name'],
          "society": userId,
        });
        EasyLoading.dismiss();
        DialogBox.showDialogBox(context, "Sent");
        _noticeFieldController.clear();
        _titleController.clear();
        setState(() {
          _selectedTower = null;
          _selectedFlat = null;
          flatList.clear();
        });
      } catch (e) {
        EasyLoading.dismiss();
        DialogBox.showDialogBox(context, "Error occurred");
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
    if (userId == null) return;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("Society").doc(userId).get();
    int totalTowers = int.parse(documentSnapshot.get("SocietyTowers"));
    List<Map<String, String>> fetchedTowerList = [];

    for (int index = 1; index <= totalTowers; index++) {
      DocumentSnapshot towersDocuments = await FirebaseFirestore.instance.collection("Towers").doc(userId + index.toString()).get();
      if (towersDocuments.exists) {
        String towerName = towersDocuments.get("TowerName");
        fetchedTowerList.add({"name": towerName, "id": userId + index.toString()});
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
              "Notice",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DropdownButton<Map<String, String>>(
                    menuMaxHeight: 200,
                    underline: Container(height: 2, color: Colors.grey.withOpacity(0.5)),
                    hint: const Text("Towers"),
                    value: _selectedTower,
                    onChanged: (newValue) async {
                      if (newValue == null) return;

                      EasyLoading.show();
                      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Towers").doc(newValue["id"]).collection("Flats").get();
                      List<dynamic> fetchedFlats = querySnapshot.docs.map((doc) => doc.get("flatNumber")).toList();

                      setState(() {
                        _selectedTower = newValue;
                        flatList = fetchedFlats;
                        _selectedFlat = null;
                      });
                      EasyLoading.dismiss();
                    },
                    items: towersList.map((e) => DropdownMenuItem(value: e, child: Text(e["name"]!))).toList(),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<dynamic>(
                    menuMaxHeight: 200,
                    underline: Container(height: 2, color: Colors.grey.withOpacity(0.5)),
                    hint: const Text("Flats"),
                    value: _selectedFlat,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedFlat = newValue;
                      });
                    },
                    items: flatList.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                maxLines: 10,
                controller: _noticeFieldController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
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
