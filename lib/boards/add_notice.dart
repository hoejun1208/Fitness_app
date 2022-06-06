import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Addnotice extends StatelessWidget {

  final _formkey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  TextEditingController title = TextEditingController();
  TextEditingController contents = TextEditingController();

  Future<void> datasave() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 작성'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed:(){
              DateTime now = DateTime.now();
              DateFormat dateFormat = DateFormat("yyyy-MM-dd");
              DateFormat timeFormat = DateFormat("HH:mm:ss");
              String date = dateFormat.format(now);
              String time = timeFormat.format(now);
              final user = _authentication.currentUser;
              loggedUser = user;
              final isVaild = _formkey.currentState!.validate();
              if(isVaild) {
                FirebaseFirestore.instance.collection("자유게시판").doc().set({
                  '제목': title.text,
                  '내용': contents.text,
                  '날짜': date,
                  '시간': time,
                  '작성자': loggedUser?.email as String,
                  '날짜시간': now,
                });
                Navigator.pop(context);
              }
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '제목',
                    hintText: '제목',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '제목을 입력해주세요.';
                    }
                    return null;
                  },
                  controller: title,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: '내용'),
                  maxLines: 15,
                  keyboardType: TextInputType.multiline,


                  validator: (value) {
                    if (value!.isEmpty) {
                      return '내용을 입력해주세요.';
                    }
                    return null;
                  },
                  controller: contents,

                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

