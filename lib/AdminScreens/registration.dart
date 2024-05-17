import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gate_keeper_app/AdminScreens/towers_configuration.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';
import 'package:gate_keeper_app/Widgets/textFormfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocietyRegistration extends StatefulWidget {
  const SocietyRegistration({super.key});
@override
 State<SocietyRegistration > createState() => _SocietyRegistrationState();
}

class _SocietyRegistrationState extends State <SocietyRegistration>{
  final _societyNameController = TextEditingController();
  final _societyAddressController = TextEditingController();
  final _cityNameController = TextEditingController();
  final _societyEmailIdController = TextEditingController();
  final _towersController = TextEditingController();
  final _adminNameController = TextEditingController();
  final _adminNumberController = TextEditingController();
  final _adminEmailController = TextEditingController();

  final List <String> states = [ 'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
    'Andaman and Nicobar Islands',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Lakshadweep',
    'Puducherry'];
  String _selectedState ="Delhi";
  void saveData() async{
    String societyName = _societyNameController.text.trim();
    String societyAddress = _societyAddressController.text.trim();
    String city = _cityNameController.text.toString();
    String state = _selectedState;
    String societyEmailId = _societyEmailIdController.text.trim();
    String societyTowers = _towersController.text.trim();
    String adminName = _adminNameController.text.trim();
    String adminMobileNumber = _adminNumberController.text.trim();
    String adminEmailId = _adminEmailController.text.trim();
    if(societyName.isEmpty ||societyAddress.isEmpty || city.isEmpty||
    societyEmailId.isEmpty || adminName.isEmpty || state.isEmpty ||
        societyTowers.isEmpty || societyTowers == "0" ||adminMobileNumber.isEmpty || adminEmailId.isEmpty
    ){
      DialogBox.showDialogBox(context, "Please fill all Details and towers should be greater than 0");
    } else {
      String userId = (await SharedPreferences.getInstance()).getString("userId")!;
    final existingSociety = await FirebaseFirestore.instance.collection("Society").doc(userId).get();
    if (existingSociety.exists) {
    // Prompt user to delete existing society
    DialogBox.showDialogBox(context, "Only one society can be added at a time. Please delete the existing society before adding a new one.");
    return;

    } else{
      EasyLoading.show();
    await FirebaseFirestore.instance.collection("Society").doc(userId).set({
      "adminId": userId,
    "SocietyName" :societyName,
    "SocietyAddress" :societyAddress,
    "State" : state,
    "City" : city,
    "SocietyEmailID": societyEmailId,
    "SocietyTowers" :societyTowers,
    });
    await FirebaseFirestore.instance.collection("admins").doc(userId).update({
      "name": adminName,
      "phoneNo" : adminMobileNumber,
      "email" : adminEmailId,
    });
    setState(() {
    _selectedState= "Delhi";
    });
      EasyLoading.dismiss();
    await DialogBox.showDialogBox(context, "Successfully Set-up");
    Navigator.push(context, MaterialPageRoute(builder: (context) => const TowersConfigurationScreen(),));
    }

    }

    _towersController.clear();
    _societyNameController.clear();
    _adminEmailController.clear();
    _societyAddressController.clear();
    _cityNameController.clear();
    _societyEmailIdController.clear();
    _adminNameController.clear();
    _adminNumberController.clear();

  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0,3),
              color: Colors.grey.withOpacity(0.5),
            )]
          ),
          child: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text("Society Set-up",
            style: TextStyle(
                fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20,40,20,0),
          child: Column(
            children: [
             TextFormFieldWidget(label: "Society Name", controller: _societyNameController),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Address", controller: _societyAddressController),
              const SizedBox(height: 20),
              DropdownButton <String>(
                underline: Container(
                  height: 2,
                  color: Colors.grey.withOpacity(0.5),
                ),
                menuMaxHeight: 200,
                hint:const  Text("States"),
                value: _selectedState,
                onChanged: (String? newValue){
                  setState(() {
                    _selectedState = newValue!;
                  });
                },
                items: states.map((e)=> DropdownMenuItem(value: e,
                child: Text(e),),).toList(),

              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "City", controller: _cityNameController),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Society Email Id", controller: _societyEmailIdController, keyboardType: TextInputType.emailAddress,),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Total Towers(1 to 9)",
                controller: _towersController,
                keyboardType: TextInputType.number,
                maxLength: 1,
              ),
              const SizedBox(height: 20),
             const  Text("Administrator Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Name", controller: _adminNameController),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Mobile Number", controller: _adminNumberController, keyboardType: TextInputType.phone,),
              const SizedBox(height: 20),
              TextFormFieldWidget(label: "Email", controller: _adminEmailController,
              keyboardType: TextInputType.emailAddress,),
              const SizedBox(height: 20),

              ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(8)),
                  onPressed: () {
                    try {
                      saveData();
                    } catch (e) {
                      DialogBox.showDialogBox(context, e.toString());
                    }
                  },
                  child: const Text("Submit")),
              const SizedBox(height: 20),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const SizedBox(width: 10,),
                   GestureDetector(
                     onTap: ()async{
                       EasyLoading.show();
                       final String userId = (await SharedPreferences.getInstance()).getString("userId")!;
                       final existingSociety= await FirebaseFirestore.instance.collection("Society").doc(userId).get();
                       if(existingSociety.exists){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => const TowersConfigurationScreen(),),);
                         EasyLoading.dismiss();
                       } else{
                         DialogBox.showDialogBox(context, "Register the Society First");
                         EasyLoading.dismiss();
                       }
                     },
                     child: const Text("Already Configured?",
                       style: TextStyle(
                         fontSize: 14,
                         fontStyle: FontStyle.italic,
                         fontWeight: FontWeight.bold,
                         decoration: TextDecoration.underline,
                       ),
                     ),
                   ),
                 ],
               ),
              const SizedBox(height: 60),

            ],
          ),
        ),
      ),
    );
  }
}

