import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/auth/login.dart';
import 'package:notesapp/auth/signup.dart';
import 'package:notesapp/crud/add.dart';
import 'package:notesapp/crud/edite.dart';
import 'package:notesapp/home/homepage.dart';
import "package:firebase_core/firebase_core.dart";



bool  islogIn =false;
void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if(user==null){
    islogIn=false;
  }else {
    islogIn=true ;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    
    routes: {
      "login" :(context)=> const Login() ,
      "signup" :(context) => const SignUp(),
      "homepage":(context) => const HomePage(),
      "addnotes":(context) => const AddNotes(),
      "editenotes":(context) => const EditeNotes(),
    },
    home: islogIn==false? const Login():const HomePage(),
    theme: ThemeData(primaryColor: Colors.blue,
        buttonTheme: const ButtonThemeData(buttonColor: Colors.blue)
    ),
    
    );
  }
}
