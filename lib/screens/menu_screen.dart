import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/material.dart.";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import "package:gate_keeper_app/Guardscreens/guard_menu_screen.dart";

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GuardMenu(),
                    ),
                  );
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
                  height: 150,
                  width: 100,
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage("assets/Guard.png"),
                   fit: BoxFit.contain

                 )
               ),
                ),),
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
                onPressed: () {},
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                child: Image.asset(
                  "assets/Resident.png",
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),),
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
                onPressed: () {},
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                child: Image.asset(
                  "assets/Admin.png",
                  width: 100,
                  height: 150,
                  fit: BoxFit.cover,
                ),),
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
    );
  }
}
