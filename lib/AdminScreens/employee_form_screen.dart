import 'package:flutter/material.dart';
class EmployeeForm extends StatefulWidget{
  const EmployeeForm({super.key});
  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}
class _EmployeeFormState extends State <EmployeeForm>{
  final List <String> items1 = ["Active", "Inactive"];
  final List <String> items2 = ["Guard", "Gardner", "Maintenance", "Cleaning Staff", "Other"];
  String selectedValue2 ="Guard";
  String selectedValue = "Active";
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _aadharController = TextEditingController();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0,3)
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
       body: SingleChildScrollView(
         child: Padding(
           padding: EdgeInsets.fromLTRB(20,40,10,0),
           child: Column(
             children: [
               CircleAvatar(
                 radius: 50,
                 backgroundImage:AssetImage("assets/Guard.png"),
               ),
               const SizedBox(height: 20),
               TextFormField(
                 controller: _nameController,
                 decoration: InputDecoration(
                   labelText: "Name",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(
                       color: Colors.deepPurple,
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 20),
               TextFormField(
                 controller: _phoneController,
                 decoration: InputDecoration(
                   labelText: "Contact Number",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(
                       color: Colors.deepPurple,
                     ),
                   ),
                 ),
               ),
               const SizedBox(height: 20),
               TextFormField(
                 controller: _aadharController,
                 decoration: InputDecoration(
                   labelText: "Aadhar Number",
                   border: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(15),
                     borderSide: BorderSide(
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
                     borderSide: BorderSide(
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
                     underline:Container(
                       height: 1,
                       color: Colors.grey,
                     ),
                     value: selectedValue,
                     onChanged:(String? newValue){
                       setState(() {
                         selectedValue = newValue!;
                       });
                     } ,
                     items: items1.map((e)=> DropdownMenuItem(
                         value: e,
                       child: Text(e,
                         style: e =="Active" ? TextStyle(
                         color: Colors.green
                       ) : TextStyle(color: Colors.red)
                       ),
                     ),
                     ).toList()
                   ),
                   DropdownButton(
                     underline: Container(
                       height: 1,
                       color: Colors.grey,
                     ),
                     menuMaxHeight: 150,
                     value: selectedValue2,
                       onChanged:(String? newValue){
                         setState(() {
                           selectedValue2 = newValue!;
                         });
                       },
                     items:items2.map((e) => DropdownMenuItem(
                         value: e,
                        child: Text(e),
                     ),
                     ).toList()
                   )
                 ],
               ),
               const SizedBox(height: 20),
               ElevatedButton(
                 style: ButtonStyle(
                   elevation: MaterialStateProperty.all(8)
                 ),
                   onPressed: (){},
                   child: Text("Submit"),
               )
             ],
           ),
         ),
       ),
    );
  }
}