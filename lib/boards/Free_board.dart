import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:health/boards/contents.dart';
import 'package:health/boards/contents_card.dart';
import './add_notice.dart';

class Free_board extends StatefulWidget {
  @override
  _Freeboard createState() => _Freeboard();
}

class _Freeboard extends State<Free_board> {

  List<Object> contentslist =[];
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getcontents();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유게시판'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return Addnotice();
                }),
              );
            },)
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
            itemCount: contentslist.length,
            itemBuilder: (context, index){
              return contentscard(contentslist[index] as contents);
            },
        )
      ),
    );
  }
  Future getcontents() async {
    var data = await FirebaseFirestore.instance.collection('자유게시판').orderBy("날짜",descending: true).get();
    setState((){
      contentslist = List.from(data.docs.map((doc) => contents.fromSnapshot(doc,doc.id)));
      print(contentslist);
    });
  }
}
