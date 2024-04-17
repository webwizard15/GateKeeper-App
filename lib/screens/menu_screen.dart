import "package:flutter/Material.dart";
import "package:gate_keeper_app/AdminScreens/admin_sign_in_screen.dart";
import "package:gate_keeper_app/GuardScreens/guard_sign_in_screen.dart";

import "package:gate_keeper_app/Guardscreens/guard_menu_screen.dart";
import "package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart";

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuardSignInScreen(),
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
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Guard.png"),
                          fit: BoxFit.contain)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Guard",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResidentMenuScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),),),
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/Resident.png"),
                  )),
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
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminSignInScreen(),
                    ),
                  );
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ))),
                child: Container(
                  height: 150,
                  width: 100,
                  decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage("assets/Admin.png"))),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Admin",
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
