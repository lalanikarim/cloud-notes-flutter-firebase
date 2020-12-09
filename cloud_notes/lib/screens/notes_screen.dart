import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_notes/screens/edit_note_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser.uid;
    var notes = FirebaseFirestore.instance
        .collection("users")
        .doc('$uid')
        .collection('notes');
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          FlatButton(
            child: Text("Logout"),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Logged out..."),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 500,
          child: StreamBuilder<QuerySnapshot>(
            stream: notes.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error loading notes: ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.active) {
                return ListView(
                  children: snapshot.data.docs
                      .map(
                        (doc) => ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 150),
                          child: Card(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ClipRRect(
                                child: ListTile(
                                  title: Text(doc.data()['title']),
                                  subtitle: Text(doc.data()['body']),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditNoteScreen(
                                          id: doc.id,
                                          doc: doc.data(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              }
              return Text("Loading...");
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNoteScreen(),
            ),
          );
        },
      ),
    );
  }
}
