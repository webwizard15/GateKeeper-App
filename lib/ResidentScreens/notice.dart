import 'package:flutter/material.dart';
class NoticeScreen extends StatelessWidget{
  final String title;
  final String description;
  const NoticeScreen({required this.title, required  this.description, super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0,3),
                blurRadius: 7,
                spreadRadius: 5,
              )
            ]
          ),
          child: AppBar(

            centerTitle: true,
            title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
        ),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}