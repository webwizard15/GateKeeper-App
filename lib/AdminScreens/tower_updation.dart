import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/AdminScreens/towers_configuration.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TowerUpdationScreen extends StatefulWidget {
  final int towerNumber;
  const TowerUpdationScreen({super.key,  required this.towerNumber});
  @override
  State <TowerUpdationScreen> createState() => _TowerUpdationScreenState();
}

class _TowerUpdationScreenState extends State<TowerUpdationScreen> {
  final _towerNameController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _maxUnitPerFloorController = TextEditingController();

  void generateFlatNumber(int convention) async {
    String towerName = _towerNameController.text.trim();
    int numberOfFloors;
    int maxUnitPerFloor;
    EasyLoading.show();
    try {
      numberOfFloors = int.parse(_floorNumberController.text.trim());
      maxUnitPerFloor = int.parse(_maxUnitPerFloorController.text.trim());
    } catch (e) {
      // Handle the exception (e.g., show an error message)
      EasyLoading.dismiss();
      DialogBox.showDialogBox(
          context, "Please enter valid numbers for floors and units per floor");
      return;
    }
    if (towerName.isEmpty || numberOfFloors <= 0 || maxUnitPerFloor <= 0) {
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context,
          "Please provide all the details and floors and units per floor should be greater than 0");
      return;
    }
    String userId = (await SharedPreferences.getInstance()).getString("userId")!;
    var exisitingTower = await FirebaseFirestore.instance
        .collection("Towers")
        .doc(userId + widget.towerNumber.toString())
        .get();
    if (exisitingTower.exists) {
      EasyLoading.dismiss();
      DialogBox.showDialogBox(context, "Tower with this name already exist");
      return;
    } else {
      await FirebaseFirestore.instance
          .collection("Towers")
          .doc(userId + widget.towerNumber.toString())
          .set({
        "TowerName": towerName,
        "societyId" :userId,
      });
      switch (convention) {
        case 1:
          for (int floor = 1; floor <= numberOfFloors; floor++) {
            for (int unit = 1; unit <= maxUnitPerFloor; unit++) {
              String flatNumber = "${(floor * 100) + unit}";
              await FirebaseFirestore.instance

                  .collection("Towers")
                  .doc(userId + widget.towerNumber.toString())
                  .collection("Flats")
                  .doc(flatNumber)
                  .set({
                "flatNumber": flatNumber,
              });
            }
          }
          break;
        case 2:
          for (int floor = 1; floor <= numberOfFloors; floor++) {
            for (int unit = 1; unit <= maxUnitPerFloor; unit++) {
              String flatNumber = "${(floor - 1) * maxUnitPerFloor + unit }";
              await FirebaseFirestore.instance
                  .collection("Towers")
                  .doc(userId + widget.towerNumber.toString())
                  .collection("Flats")
                  .doc(flatNumber)
                  .set({
                "flatNumber": flatNumber,
              });
            }
          }
          break;
        case 3:
          for (int floor = 0; floor <= numberOfFloors; floor++) {
            for (int unit = 1; unit <= maxUnitPerFloor; unit++) {
              String flatNumber;
              if (floor == 0) {
                flatNumber = "G$unit";
              } else {
                flatNumber = "${floor}0$unit";
              }
              await FirebaseFirestore.instance
                  .collection("Towers")
                  .doc(userId + widget.towerNumber.toString())
                  .collection("Flats")
                  .doc(flatNumber)
                  .set({
                "flatNumber": flatNumber,
              });
            }
          }
          break;
        case 4:
          for (int floor = 0; floor < numberOfFloors; floor++) {
            for (int unit = 1; unit <= maxUnitPerFloor; unit++) {
              String flatNumber;
              if (floor == 0) {
                flatNumber = "G$unit";
              } else {
                flatNumber = "${(floor * maxUnitPerFloor) + unit}";
              }
              await FirebaseFirestore.instance
                  .collection("Towers")
                  .doc(userId + widget.towerNumber.toString())
                  .collection("Flats")
                  .doc(flatNumber)
                  .set({
                "flatNumber": flatNumber,
              });
            }
          }
          break;
        case 5:
          for (int floor = 0; floor < numberOfFloors; floor++) {
            for (int unit = 1; unit <= maxUnitPerFloor; unit++) {
              String flatNumber;
              if (floor == 0) {
                flatNumber = "G$unit";
              } else {
                flatNumber = "${(floor * maxUnitPerFloor) + unit}";
              }
              await FirebaseFirestore.instance
                  .collection("Towers")
                  .doc(userId + widget.towerNumber.toString())
                  .collection("Flats")
                  .doc(flatNumber)
                  .set({
                "flatNumber": flatNumber,
              });
            }
          }
          break;

        default:
      }
      EasyLoading.dismiss();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TowersConfigurationScreen(),));
    }
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
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
                offset: const Offset(0, 3)),
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
              TextFormField(
                controller: _towerNameController,
                decoration: InputDecoration(
                    labelText: "Tower name",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _floorNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Number of Floors",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _maxUnitPerFloorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Maximum unit per floor",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.deepPurple,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Choose the naming convention",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    //First Convention
                    child: ElevatedButton(
                      onPressed: () {
                        generateFlatNumber(1);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("301"),
                              Text("302"),
                              Text("303"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("201"),
                              Text("202"),
                              Text("203"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("101"),
                              Text("102"),
                              Text("103"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    //Second Convention
                    child: ElevatedButton(
                      onPressed: () {
                        generateFlatNumber(2);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("7"),
                              Text("8"),
                              Text("9"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("4"),
                              Text("5"),
                              Text("6"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("1"),
                              Text("2"),
                              Text("3"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    //Third Convention
                    child: ElevatedButton(
                      onPressed: () {
                        generateFlatNumber(3);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("201"),
                              Text("202"),
                              Text("203"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("101"),
                              Text("102"),
                              Text("103"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("G1"),
                              Text("G2"),
                              Text("G3"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    //Fourth Convention
                    child: ElevatedButton(
                      onPressed: () {
                        generateFlatNumber(4);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("4"),
                              Text("5"),
                              Text("6"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("1"),
                              Text("2"),
                              Text("3"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("G1"),
                              Text("G2"),
                              Text("G3"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                //Fifth Convention
                onPressed: () {
                  generateFlatNumber(5);
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),

                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("4"),
                        Text("5"),
                        Text("6"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("1"),
                        Text("2"),
                        Text("3"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("G1"),
                        Text("G2"),
                        Text("G3"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
