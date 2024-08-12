
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../component/alert.dart';
import '../home/homepage.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}
 
class _LoginState extends State<Login> {
  dynamic  myPassword,myEmail ;
  GlobalKey<FormState>formstate=GlobalKey<FormState>();
  signIn()async {
    var formdata =formstate.currentState;
    if (formdata!.validate()){
      formdata.save();
   try {
    showLoading(context);
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
     email : myEmail ,
    password: myPassword,
  );
    
  return credential ;
} on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    Navigator.of(context).pop();
    AwesomeDialog(context: context,title: "Error",
    body: const Text("No user found for that email")).show();
  } else if (e.code == 'wrong-password') {
     Navigator.of(context).pop();
     AwesomeDialog(context: context,title: "Error",
    body: const Text("Wrong password provided for that user")).show();
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
         const SizedBox(height: 50,),
          Container(padding: const EdgeInsets.all(40),
            child: Form(
              key: formstate,
              child:Column(children: [
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
                  hintText: "Email",
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
                    const Text("to create acount  "),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("signup");
                  },
                  child: const Text("click here",style: TextStyle(color: Colors.blue),),)
                ]),
              ),
              const SizedBox(height: 10,),
              Container(
                color: Colors.blue,
                child: ElevatedButton(onPressed: ()async{
                  UserCredential ?userc = await  signIn();
                  if (userc!=null){
                    if(context.mounted){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>const HomePage()), (route) => false);
                    }
                  }
                },child:const Text("LOGIN") ),
              )
            ],)),
          )
        ],
      ),
    );
  }
}