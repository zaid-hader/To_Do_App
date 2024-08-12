import 'package:flutter/material.dart';

showLoading( context){
   showDialog (context: context , builder : ( context ){
     return const AlertDialog( 
      title:  Text("please wait"),
      content: SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator())),
        
    ) ;
   });
}

