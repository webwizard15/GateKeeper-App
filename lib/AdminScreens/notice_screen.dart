import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/add_notice_screen.dart';

class Notice extends StatefulWidget {
  const Notice({super.key});
  @override
  State<Notice> createState()=> _NoticeState();
}

class _NoticeState extends State<Notice>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
       appBar: PreferredSize(
         preferredSize: const Size.fromHeight(kToolbarHeight),
       child: Container(
         decoration: BoxDecoration(
           boxShadow: [BoxShadow(
             color: Colors.grey.withOpacity(0.5),
             offset: const Offset(0,3),
             blurRadius: 7,
             spreadRadius: 5,
           )]
         ),
         child: AppBar(
           elevation: 0,
           centerTitle: true,
           title: const Text("Notices", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
         ),
       ),
       ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNotice(),));
        },
        child: const Icon(Icons.add),
      )
    );
  }
}