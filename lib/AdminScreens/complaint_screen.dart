import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gate_keeper_app/Widgets/dialogue_box.dart';

class AdminComplaintScreen extends StatefulWidget {
  final String title;
  final String description;
  final String photo;
  final String? id;

  const AdminComplaintScreen({
    required this.title,
    required this.description,
    required this.photo,
    required this.id,
    super.key,
  });

  @override
  State<AdminComplaintScreen> createState() => _AdminComplaintScreenState();
}

class _AdminComplaintScreenState extends State<AdminComplaintScreen> {
  final TextEditingController _commentController = TextEditingController();
  String? fetchedComment;
   // Added loading state

  @override
  void initState() {
    super.initState();
    fetchComment();
  }

  void fetchComment() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection(
        "complaints").doc(widget.id).get();
    if (doc.exists) {
      setState(() {
        fetchedComment = doc['comment'];
      });
    }
  }

  void uploadData() async {
    String comment = _commentController.text.trim();
    if (comment.isEmpty) {
      DialogBox.showDialogBox(context, "Please write a comment");
      return;
    } else {
      await FirebaseFirestore.instance.collection("complaints")
          .doc(widget.id)
          .update({
        "isClosed": true,
        "comment": comment,
      });
      setState(() {
        fetchedComment =
            comment; // Update fetchedComment after adding the comment
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 3),
                blurRadius: 7,
                spreadRadius: 5,
              ),
            ],
          ),
          child: AppBar(
            centerTitle: true,
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InteractiveViewer(
                child: Image.network(
                  widget.photo,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              const Text(
                'Comments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              fetchedComment ==
                    null
                    ? Column(
                  children: [
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: uploadData,
                      child: const Text('Submit'),
                    ),
                  ],
                )
                  : Text(
                  fetchedComment!,
                  style: const TextStyle(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}