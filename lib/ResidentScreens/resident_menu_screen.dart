

import 'package:flutter/material.dart';

class ResidentMenuScreen extends StatelessWidget{
  const ResidentMenuScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration:BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                spreadRadius: 5,
                offset:Offset(0,3)
              ),
            ]
          ),
          child: AppBar(),
        ),
      ),
      drawer: Drawer(
          width: 200,
        child: ListView(
          children: [
                DrawerHeader(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage:AssetImage("assets/Man.png"),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                   Text("Anmol Shukla", style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
            ),
            ListTile(
              leading: Icon(Icons.event_note_outlined, size:20),
              title:Text("Complaints",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.people, size:20),
              title:Text("Visitors",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.phone_android, size:20),
              title:Text("Contact us",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.logout, size:20),
              title:Text("Log Out",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
              onTap: (){

              },
            ),
            Divider(

            ),
          ],
        )
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: Column(
            children: [
             ElevatedButton(
                 onPressed: (){},
                 style: ButtonStyle(
                   elevation: MaterialStateProperty.all(10),
                   shape: MaterialStateProperty.all(
                       RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                   ),
                 ),
                 child: Container(
                   height: 150,
                   width: 100,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage(
                         "assets/Approvals.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
              Text("Approvals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 onPressed: (){},
                 style: ButtonStyle(
                   elevation: MaterialStateProperty.all(10),
                   shape: MaterialStateProperty.all(
                       RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                   ),
                 ),
                 child: Container(
                   height: 150,
                   width: 100,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage(
                         "assets/Notice.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
              Text("Notice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 onPressed: (){},
                 style: ButtonStyle(
                   elevation: MaterialStateProperty.all(10),
                   shape: MaterialStateProperty.all(
                       RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                       ),
                   ),
                 ),
                 child: Container(
                   height: 150,
                   width: 100,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage(
                         "assets/Report.png",
                       )
                     )
                   ),
                 )
             ),
              const SizedBox(height: 10),
              Text("Complaints",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}