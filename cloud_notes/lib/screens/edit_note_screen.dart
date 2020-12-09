import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNoteScreen extends StatelessWidget {
  EditNoteScreen({Key key, this.id, this.doc}) : super(key: key);

  String id;
  Map<String, dynamic> doc;

  @override
  Widget build(BuildContext context) {
    if (doc == null) {
      doc = {"title": "", "body": ""};
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(id == null ? "New Note" : "Edit Note"),
        actions: [
          FlatButton(
            child: Text("Save"),
            onPressed: () async {
              var uid = FirebaseAuth.instance.currentUser.uid;
              var userDoc =
                  FirebaseFirestore.instance.collection("users").doc('$uid');
              var notes = userDoc.collection('notes');
              try {
                if (doc['title'].length > 0 && doc['body'].length > 0) {
                  if (id == null) {
                    await notes.add(doc);
                  } else {
                    await notes.doc(id).update(doc);
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          id == null ? "Note created..." : "Note updated..."),
                    ),
                  );
                } else {
                  throw new Exception("Title or content empty.");
                }
              } on FirebaseException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: ${e.message}"),
                  ),
                );
              } catch (err) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $err"),
                  ),
                );
              }
            },
          ),
          Visibility(
            visible: id != null,
            child: FlatButton(
              child: Text("Delete"),
              onPressed: () async {
                var uid = FirebaseAuth.instance.currentUser.uid;
                var userDoc =
                    FirebaseFirestore.instance.collection("users").doc('$uid');
                var notes = userDoc.collection('notes');
                try {
                  await notes.doc(id).delete();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Note deleted..."),
                    ),
                  );
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $err"),
                    ),
                  );
                }
              },
            ),
          ),
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Title",
                    ),
                    initialValue: doc['title'],
                    maxLength: 140,
                    onChanged: (value) {
                      doc['title'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Note",
                    ),
                    initialValue: doc['body'],
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    onChanged: (value) {
                      doc['body'] = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
