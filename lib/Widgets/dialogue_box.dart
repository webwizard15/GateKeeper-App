
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DialogBox {
  static showDialogBox (BuildContext context, String message,
      {bool isEdit = false, String? userId,  String? name}){
    TextEditingController controller = TextEditingController( text: name);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DialogBox'),
        content: Container(
          height: isEdit? 100 : 50,
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(message),
            if(isEdit)
              ...[const Text("But you can edit the name"),
                SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Name:"),
                      SizedBox(
                        width: 100,
                        child: TextFormField(controller: controller,),
                      )
                    ],
                  ),
                )]

          ],
        ),),
        actions: [
          TextButton(
              onPressed: (){
                if(controller.text.trim() == ""){
                  Navigator.of(context).pop();
                  return;
                }
                FirebaseFirestore.instance.collection("Towers").doc(userId).update({
                  "TowerName": controller.text.trim()
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
          ),
          if(isEdit)
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      )
    );
  }
}