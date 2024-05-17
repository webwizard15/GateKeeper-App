import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/AdminScreens/add_notice_screen.dart';
import 'package:gate_keeper_app/ResidentScreens/notice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoticeList extends StatefulWidget {
  const NoticeList({super.key});
  @override
  State<NoticeList> createState()=> _NoticeListState();
}

class _NoticeListState extends State<NoticeList>{
  String ?societyUserId;
  String ?towerId;
  String ?flat;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }
  void _initializeData()async{
    String ? societyUserId = (await SharedPreferences.getInstance()).getString("society");
    String? residentUserId = (await SharedPreferences.getInstance()).getString("userId");
   DocumentSnapshot doc= await FirebaseFirestore.instance.collection("resident").doc(residentUserId).get();
   String towerId = doc["tower"];
   String flatNumber =doc["flat"];
   setState(() {
     societyUserId = societyUserId;
     towerId = towerId;
     flat =flatNumber;
   });
    }
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("notices").where("society", isEqualTo: societyUserId).where("tower.id", isEqualTo: towerId).where("flat", isEqualTo: flat).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState ==ConnectionState.waiting){
              return Expanded(
                child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: const Center(child: CircularProgressIndicator())),
              );
            } else if (snapshot.hasError){
              return Expanded(
                child: Container(
                    height: MediaQuery.sizeOf(context).height,
                    width: MediaQuery.sizeOf(context).width,
                    child: Center(child: Text('Error: ${snapshot.error}')),
                )
              );
            } else {
              final docs = snapshot.data!.docs.toList();
              return ListView.builder(
                itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final noticeTitle = docs[index]["title"];
                    final noticeDescription = docs[index]["notice"];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        elevation: 5,
                        child: ListTile(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => NoticeScreen(title: noticeTitle, description: noticeDescription),));
                          },
                          title: Text(noticeTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(noticeDescription,maxLines: 1,),
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}