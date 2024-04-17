import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/employee_form_screen.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});
  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmployeeForm(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3)),
            ],
          ),
          child: AppBar(
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
