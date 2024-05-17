import 'package:flutter/Material.dart';
import 'package:gate_keeper_app/GuardScreens/visitor_form.dart';

class GuardMenu extends StatefulWidget {
  const GuardMenu({super.key});

  @override
  State<GuardMenu> createState() => _GuardMenuState();
}

class _GuardMenuState extends State<GuardMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //creating customise tool bar
        preferredSize:
            const Size.fromHeight(kToolbarHeight), //setting standard height
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: const Text(
              'Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
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
            const DrawerHeader(
              padding: EdgeInsets.all(10),
              //first is header
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/Guard.png"),
                    radius: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Anmol Shukla",
                      style: TextStyle(fontWeight: FontWeight.bold,),
                    ),
                  )
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 25,
              ),
              title: const Text(
                "Log Out",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                // changeSelected(0);
              },
            ),
            const Divider(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const VisitorForm(),
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
                      image: AssetImage("assets/Visitor.png"),
                      fit: BoxFit
                          .contain, // Use BoxFit.contain or BoxFit.scaleDown
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
                  // Add your onPressed logic here
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
                  // Add your onPressed logic here
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
                      image: AssetImage("assets/LogEntry.png"),
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

            ],
          )
        ],
      ),
    );
  }
}
