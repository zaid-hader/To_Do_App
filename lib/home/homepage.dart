

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/auth/login.dart';
import 'package:notesapp/crud/edite.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
CollectionReference noteref = FirebaseFirestore.instance.collection("notes");
 
class _HomePageState extends State<HomePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Notes Page"),
        actions: [IconButton(onPressed: () {
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: const Text("WARNING"),
              content: const Text("Are You Sure To LogOut ?"),
              actions: [TextButton(onPressed: ()async{
                {
          await FirebaseAuth.instance.signOut();
          if(context.mounted){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
  builder: (context)=>const Login()), (route) => false);
          }
        }
              }, child: const Text("Ok")),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text("Cancel"))],
            );
          });
        }
        , icon:const Icon( Icons.exit_to_app))],),
    floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.of(context).pushNamed("addnotes");
    },
    child: 
    const Icon(Icons.add,),
    ),
     floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat ,
    body: FutureBuilder(future: 
    noteref.where("userid",isEqualTo: FirebaseAuth.instance.currentUser?.uid).get()
    , builder: (context, snapshot){
      if(snapshot.hasData){
        return ListView.builder(
      itemCount: snapshot.data?.docs.length,
      itemBuilder: (BuildContext context, int i) {
        return ListNotes(
          
          notes: snapshot.data?.docs[i],
        docid:snapshot.data?.docs[i].id ,);
      
      },
     
    );
      }
      return const Center(child: CircularProgressIndicator(),) ;
    })
    
    );
    
  }
}

class ListNotes extends StatelessWidget {
  
  final dynamic docid;
final dynamic notes ;
  const ListNotes({super.key, this.notes,this.docid});
  @override
  Widget build(BuildContext context){
  return  InkWell(
    onTap: () {
      showDialog(context: context, builder: (context){
     return AlertDialog( 
      title: Text(notes['title'],),
     content:
    
        SizedBox(
          height: 500,
          child: ListWheelScrollView(
            useMagnifier: true  ,
            squeeze: 2,
               itemExtent:400 ,
               children: [
                Text(notes['note']),
               
               const SizedBox(height: 20,),
               
                SizedBox(
                  height: 400,
                  child: Image.network("${notes['imageurl']}",fit: BoxFit.cover,height: 400,))
              ],),
        ),     
      
     
     actions: [TextButton(onPressed: () {
       Navigator.of(context).pop();
     },
     
     child:const Text("exit",style: TextStyle(fontSize: 23),),
     )],
       );
      });
    },
    child: Card(
      
      child: Row(
        children: [
            Expanded(
           flex: 1,
           
           child:Image(image: NetworkImage("${notes['imageurl']}"),fit: BoxFit.fill,)
           ),
  
          Expanded(
            
            flex: 4,
            child: 
            ListTile(
              
              title: Text("${notes['title']}" ,style:const TextStyle(fontSize: 20),),
              subtitle:  Text("${notes['note']}"),
            )),
             Expanded(
               child: Column(
                children: [
                         Padding(
                           padding: const EdgeInsets.fromLTRB(5, 1, 5, 15),
                           child: IconButton(icon: const Icon(Icons.edit,size: 30,color: Colors.green, )
                                           ,
                                           onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return  EditeNotes(docid:docid,list: notes,);
                            }));
                                           },),
                         ),
  
                     Padding(
                       padding: const EdgeInsets.fromLTRB(5, 1, 5, 5),
                       child: IconButton(onPressed: () {
                        showDialog(context: context, builder: (context){
                         return AlertDialog(
                          title:const Text ("warning"),
                          content:const Text("Are You Sure To Delete This Note"),
                          actions: [TextButton(onPressed: () async{
                              await noteref.doc(docid).delete();
                       await FirebaseStorage.instance.refFromURL(notes['imageurl']).delete();
                       
                       if (context.mounted){
                      
                       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (context)=>const HomePage()), (route) => false);      
                       }
                      
                          }, child:const Text("Ok")),
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                          
                          }, child:const Text("Cancel"))
                          
                          ],
                         );
                        });
                       }
                       
                       ,
                     icon:const Icon(Icons.delete,size: 30,color: Colors.red,)),
                     ),
                ],
                       ),
             ),
            
          
        ],
      ),
    ),
  );
  }
}