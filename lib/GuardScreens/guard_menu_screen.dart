import 'package:flutter/Material.dart';

class GuardMenu extends StatefulWidget {
  const GuardMenu({super.key});

  @override
  State<GuardMenu> createState() => _GuardMenuState();
}

class _GuardMenuState extends State<GuardMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(  //creating customise tool bar
        preferredSize:
            Size.fromHeight(kToolbarHeight), //setting standard height
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: Text(
              'Menu',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
              ),
            ), // App bar color
            elevation: 0, // Remove default app bar elevation
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          children: [
                DrawerHeader(   //first is header
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                      backgroundImage:AssetImage( "assets/Guard.png"),
                        radius: 50,
                      ),
                      Text("Anmol Shukla", style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
            ListTile(
              leading:Icon(
                Icons.logout,
                size: 20,

              ),
              title: Text("Log Out",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize:20,
                ),
              ),
              onTap: () {
                // changeSelected(0);
              },
            ),
            Divider(
             thickness: 2,
              indent: 8,
              endIndent: 8,

            )
          ],
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed logic here
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/Visitor.png"),
                      fit: BoxFit.contain, // Use BoxFit.contain or BoxFit.scaleDown
                    ),
                  ),
                ),
              ),
               const SizedBox(height: 20),
              const Text(
                "Visitors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  // Add your onPressed logic here
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/Resident.png"),
                      fit: BoxFit.contain, // Use BoxFit.contain or BoxFit.scaleDown
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
                  // Add your onPressed logic here
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/Maid.png"),
                      fit: BoxFit.contain, // Use BoxFit.contain or BoxFit.scaleDown
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
                  // Add your onPressed logic here
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(10),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                child: Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: AssetImage("assets/LogEntry.png"),
                      fit: BoxFit.contain, // Use BoxFit.contain or BoxFit.scaleDown
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "LogEntry",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
            ],
          )
        ],
      ),
    );
  }
}
