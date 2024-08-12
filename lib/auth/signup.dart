import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/component/alert.dart';

import '../home/homepage.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
dynamic myUserName,myPassword,myEmail ;
  GlobalKey<FormState>formstate=GlobalKey<FormState>();
 signUp() async{
  var formdata = formstate.currentState ;
  if(formdata!.validate()){
formdata .save();
try {
  showLoading(context);
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: myEmail,
    password: myPassword,
  );
  return credential ;
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    Navigator.of(context).pop();
    AwesomeDialog(context: context, title: "Error",
    body: const Text("The password provided is too weak")).show();
  } else if (e.code == 'email-already-in-use') {
    Navigator.of(context).pop();
    AwesomeDialog(context: context,title: "Error",
    body:const Text("The account already exists for that email")).show();
  }
} 
  }
 
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 120,),
           Center(
              child: Image.asset("images/logo.png",height: 200,width: 200,)),
          const SizedBox(height: 30,),
          Container(padding: const EdgeInsets.all(40),
            child: Form(
              key: formstate,
              child:Column(children: [
              TextFormField(
                onSaved: (newValue) {
                  myUserName=newValue;
                },
                validator: (value) {
                  if (value!.length>100) {
                    return "user name cant be more than 100 letters";
                  }
                  if (value.length<2){
                    return "user name cant be less than 2 letters";
                  }
                  return null ;

                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: "username",
                  hintStyle: TextStyle(fontSize:20 ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1)
                )
              ),),
              const SizedBox(height: 20,)
              ,
              TextFormField(
                onSaved: (newValue) {
                  myEmail=newValue;
                },
                  validator: (value) {
                  if (value!.length>100) {
                    return "Emale cant be more than 100 letters";
                  }
                  if (value.length<2){
                    return "Emale cant be less than 2 letters";
                  }
                  return null ;

                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: "email",
                  hintStyle: TextStyle(fontSize:20 ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1)
                )
              ),),
              const SizedBox(height: 20,)
              
              ,TextFormField(
                onSaved: (newValue) {
                  myPassword = newValue;
                },
                  validator: (value) {
                  if (value!.length>100) {
                    return "Password cant be more than 100 letters";
                  }
                  if (value.length<4){
                    return "Password cant be less than 4 letters";
                  }
                  return null ;

                },
                obscureText: true,
                decoration: const InputDecoration(
                  
                  prefixIcon: Icon(Icons.key),
                  hintText: "password",
                  hintStyle: TextStyle(fontSize:20 ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1)
                )
              ),),
              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    const Text(" if you have account  "),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                  child: const Text("click here",style: TextStyle(color: Colors.blue),),)
                ]),
              ),
              const SizedBox(height: 10,),
              Container(
                color: Colors.blue,
                child: ElevatedButton(onPressed: () async{
                  
                 UserCredential ?response= await signUp();
                 if (response!=null){
                  await FirebaseFirestore .instance.collection("users").add({
                    "username":myUserName,
                    "email" :myEmail
                  }
                  );
                  if(context.mounted){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>const HomePage()), (route) => false);
                 }}
                },
                child:const Text("CREATE ACCOUNT") ),
              )
            ],)),
          )
        ],
      ),
    );
  }
}