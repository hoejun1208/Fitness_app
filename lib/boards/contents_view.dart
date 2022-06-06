import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/boards/contents.dart';
import 'package:intl/intl.dart';

import 'comment.dart';
import 'comment_card.dart';
class contents_view extends StatefulWidget {
  const contents_view({Key? key, required this.contentslist}) : super(key: key);
  final contents contentslist;
  @override
  State<contents_view> createState() => _contents_view(contentslist: contentslist);
}

class _contents_view extends State<contents_view> {
  _contents_view({Key? key, required this.contentslist});
  final contents contentslist;
  List<Object> commentlist =[];
  var _isLoading = false;
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    getcomment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          contentslist.title!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: (){},
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE6E6E6),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffCCCCCC),
                        ),
                      ),
                    ),
                    title: Text('익명'),
                    subtitle: Text(contentslist.date! + "  " +contentslist.time!),
                  ),
                  //제목
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Text(
                      contentslist.title!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  //내용
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(contentslist.content!),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                  ),

                  commentlist.isEmpty
                  ?Center(
                    child: Text('No comments'),
                  )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("자유게시판").doc(contentslist.id).collection("댓글").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                      case ConnectionState.waiting: return CircularProgressIndicator();
                      default:
                      return SizedBox(
                        height: 400,
                        child: new ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        return new ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              backgroundColor: Color(0xffE6E6E6),
                              child: Icon(
                                Icons.person,
                                color: Color(0xffCCCCCC),
                              ),
                            ),
                          ),
                        title: new Text(document['작성자']),
                        subtitle: new Text(document['내용']),
                        );
                        }).toList(),
                        ),
                      );
                      }},),

                ],
              ),
            ),
          ),
          Align(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Flexible(
                      child: Container(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            focusNode: _commentFocusNode,
                            controller: _commentTextEditController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return '댓글을 입력하세요.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              hintText: "댓글을 입력하세요.",
                              hintStyle: new TextStyle(color: Colors.black26),
                              suffixIcon: _isLoading
                                  ? CircularProgressIndicator()
                                  : IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  String commentText =
                                      _commentTextEditController.text;
                                  print('input comment: ' +
                                      _commentTextEditController.text);

                                  if (_formKey.currentState!.validate()) {
                                    DateTime now = DateTime.now();
                                    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                                    DateFormat timeFormat = DateFormat("HH:mm:ss");
                                    String date = dateFormat.format(now);
                                    String time = timeFormat.format(now);
                                    final user = _authentication.currentUser;
                                    loggedUser = user;

                                    FirebaseFirestore.instance.collection("자유게시판").doc(contentslist.id).collection("댓글").doc().set({
                                      '내용': commentText,
                                      '날짜': date,
                                      '시간': time,
                                      '작성자': loggedUser?.email as String,
                                      '날짜시간': now,
                                    });

                                    _commentTextEditController.clear();
                                    _commentFocusNode.unfocus();

                                    /*if (post.userId != authUserId) {
                                      _addNotification(
                                          post.title!,
                                          commentText,
                                          post.id!,
                                          post.userId!);
                                    }*/
                                  } else {
                                    null;
                                  }
                                },
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
      ),
    );
  }
  Future getcomment() async {
    var data = await FirebaseFirestore.instance.collection('자유게시판').doc(contentslist.id).collection("댓글").orderBy("날짜",descending: true).get();
    setState((){
      commentlist = List.from(data.docs.map((doc) => comment.fromSnapshot(doc,doc.id)));
      print(contentslist);
    });
  }
}
