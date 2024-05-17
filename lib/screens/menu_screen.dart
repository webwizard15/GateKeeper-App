import "package:flutter/Material.dart";
import "package:gate_keeper_app/AdminScreens/admin_sign_in_screen.dart";
import "package:gate_keeper_app/GuardScreens/guard_sign_in_screen.dart";

import "package:gate_keeper_app/Guardscreens/guard_menu_screen.dart";
import "package:gate_keeper_app/ResidentScreens/resident_menu_screen.dart";
import "package:gate_keeper_app/ResidentScreens/resident_sign_in_screen.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../AdminScreens/admin_menu_screen.dart";

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences value){
      String? id = value.getString("userId");
      if(id != null && id != "" ){
        switch(value.getInt("type")){
          case 0: // admin
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminMenuScreen()));
            break;
          case 1: // Res
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ResidentMenuScreen()));
            break;
          case 2: // Guard
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const GuardMenu()));
            break;
        }
      }
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                      builder: (context) => const ResidentSignInScreen(),
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
