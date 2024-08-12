
import 'dart:io';
import 'dart:math';
//import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notesapp/component/alert.dart';
import 'package:path/path.dart';

import '../home/homepage.dart';
class EditeNotes extends StatefulWidget {
  final dynamic docid ;
  final dynamic list ;
  const EditeNotes({super.key,this.docid,this.list,});

  @override
  State<EditeNotes> createState() => _EditeNotesState();
}
class _EditeNotesState extends State<EditeNotes> {
CollectionReference noteref =FirebaseFirestore.instance.collection("notes");
  Reference ?ref ;
     File ?file ;
dynamic title ,note ,imageurl ;

GlobalKey<FormState> formstate =GlobalKey<FormState>();

 
editeNotes(context) async{
  var formdata =formstate.currentState;
  if(file == null){
   if(formdata!= null &&  formdata.validate()){
    showLoading( context);
formdata.save();
await noteref.doc(widget.docid).update({
  "title" : title,
  "note" : note,
}).then((value) {
   Navigator.of( context ).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>const HomePage()), (route) => false);
}).catchError((e){});


  }
  }else{
  if(formdata!= null &&  formdata.validate()){
    showLoading( context);
formdata.save();
 await FirebaseStorage.instance.refFromURL(widget.list['imageurl']).delete();
await ref?.putFile(file!);
   imageurl = await ref?.getDownloadURL();
   
await noteref.doc( widget.docid).update({
  "title" : title,
  "note" : note,
  "imageurl":imageurl,
}).then((value) {
  Navigator.of( context ).pushAndRemoveUntil(MaterialPageRoute(
  builder: (context)=>const HomePage()), (route) => false);
}).catchError((e){})
;
  }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title:const Text("Edite Note"),
    ),
    body: ListView(
      children: [
        Form(
          key: formstate,
          child: Column(
          children: [
            TextFormField(
              initialValue: widget.list['title'],
              validator: (value) {
                  if (value!.length>30) {
                    return "title cant be more than 30 letters";
                  }
                  if (value.length<2){
                    return "title cant be less than 2 letters";
                  }
                  return null ;

                },
              onSaved: (newValue) {
                title =newValue;
              },
              maxLength: 30,
              decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText:"Note Title",
              
              prefixIcon: Icon(Icons.abc ,size:50 ,)
            ),),
            TextFormField(
              initialValue: widget.list['note'],
              validator: (value) {
                  if (value!.length>200) {
                    return "note cant be more than 200 letters";
                  }
                  if (value.length<2){
                    return "note cant be less than 2 letters";
                  }
                  return null ;

                },
              onSaved: (newValue) {
                note =newValue;
              },
              minLines: 1,
              maxLines: 8,
              maxLength: 200,
              decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText:"Note ",
              prefixIcon: Icon(Icons.abc ,size:50 ,)
            ),),
            const SizedBox(height: 100,)
            ,
            Padding(padding: 
            const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () { 
                showModalBottomSheet(context: context, builder: (context){
                return SizedBox(
                  height: 200,
                  child: Column(children: [
                    const Text("please choose image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    InkWell(
                      onTap: ()async {
                        var picked =await ImagePicker().pickImage(source: ImageSource.gallery);
                          if(picked !=null){
                          file=File(picked.path);
                          var rand =Random().nextInt(100000);
                          var nameimage ='$rand ${basename(picked.path)}';
                           ref= FirebaseStorage.instance.ref("images").child(nameimage);
                           if(context.mounted){
                            Navigator.of(context).pop();
                           }

                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: const Row(
                          children: [
                           Icon(Icons.photo_camera_back,size: 30,),
                           SizedBox(width: 20,),
                            Text("From Gallery",style: TextStyle(fontSize: 20),),
                          ],
                        ),
                      ),
                    ),

                       InkWell(
                      onTap: ()async {
                        var picked = await ImagePicker().pickImage(source: ImageSource.camera);
                        if(picked !=null){
                          file=File(picked.path);
                          var rand =Random().nextInt(100000);
                          var nameimage ='$rand ${basename(picked.path)}';
                           ref= FirebaseStorage.instance.ref("images").child(nameimage);
                           if(context.mounted){
                           Navigator.of(context).pop();
                           }
                        }

                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        child: const Row(
                          children: [
                           Icon(Icons.camera,size: 30,),
                           SizedBox(width: 20,),
                           Text("From Camera",style: TextStyle(fontSize: 20),)
                          ],
                        ),
                      ),
                    )
                  ],),
                );
                }
                );
              
              },
              child:const Text(" Edite photo ") ),),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                     
                    onPressed: () async{
                    await  editeNotes(context);
              }, 
                   child:
                   const Text("Save edited Note")),
            ),
          ],
        ))
       , 
      ],
    ),
    );
  }
}

 
