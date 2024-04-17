import 'package:flutter/Material.dart';
import 'package:flutter/services.dart';// this is imported for using length limiting factor

class VisitorForm extends StatefulWidget{
  const VisitorForm({super.key});
  @override
  State <VisitorForm> createState() => _VisitorFormState();
}
class _VisitorFormState extends State <VisitorForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController =TextEditingController();
  var _towers;
  var _flats;
  List towersList = [
    "Tower 1","Tower 2","Tower 3","Tower 4","Tower 5","Tower 6",
  ] ;
  List flatsList =["FLat 101","FLat 102 ","FLat 103","FLat 104","FLat 105","FLat 106","FLat 107","FLat 108" ];
  @override
  Widget build(BuildContext context){
    return Scaffold(
         appBar: PreferredSize(
           preferredSize:const Size.fromHeight(kToolbarHeight),
           child: Container(
             decoration: BoxDecoration(
               boxShadow:[
                 BoxShadow(
                   color: Colors.grey.withOpacity(0.5),
                   spreadRadius:5,
                   blurRadius:7,
                   offset: const Offset(0,3),
                 ),
               ]
             ),
             child: AppBar(
               elevation: 0,
             ),
           ),
         ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 40, 20,0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/Man.png"),
                      )

                  ),
                ),
                Positioned(
                  left: 82,
                  top: 82,
                  child: IconButton(
                    onPressed: (){},
                      icon: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  )
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), //limiting the length to 10 numbers only.
              ],
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon:const Icon(Icons.phone),
                focusedBorder:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide:const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  )
                )
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
                  menuMaxHeight: 200,
                  hint:const Text("Towers"),
                  value: _towers, // default selected item is null
                  onChanged: (newValue){
                    setState(() {
                      _towers=newValue;   //selected item is passed into a variable and rebuilt the Widget
                    });
                  },
                  items: towersList.map((e) => DropdownMenuItem(
                    value: e,
                     child: Text(e),
                  )).toList(),
                ),
                DropdownButton(
                  underline: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  menuMaxHeight: 200,
                  hint: const Text("Flats"),
                  value: _flats,
                  onChanged: (newValue){
                    setState(() {
                      _flats = newValue;
                    });
                  },
                  items: flatsList.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
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
                  )
                )
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(8)
                ),
                onPressed: (){

                },
                child:const Text("Submit")
            )
          ],
        ),
      )
    );
  }
}