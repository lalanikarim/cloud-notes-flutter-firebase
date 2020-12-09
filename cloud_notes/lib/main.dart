import 'package:cloud_notes/screens/login_screen.dart';
import 'package:cloud_notes/screens/notes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> firebaseApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloud Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<FirebaseApp>(
        future: firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorView(error: snapshot.error);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return AuthPage();
          }
          return LoadingScreen();
        },
      ),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorView(
            error: snapshot.error,
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            return NotesScreen();
          } else {
            return LoginScreen();
          }
        }
        return LoadingScreen();
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key key, this.error}) : super(key: key);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Text("Error encountered: $error"),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: CircularProgressIndicator(),
    );
  }
}
