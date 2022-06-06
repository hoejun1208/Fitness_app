import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/boards/contents.dart';

class contents_view extends StatelessWidget {
  final contents contentslist;
  var _isLoading = false;
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  final _commentFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _commentTextEditController = TextEditingController();
  contents_view({Key? key, required this.contentslist}) : super(key: key);

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
                    height: 1,
                  ),
                  Divider(
                    thickness: 1,
                  ),

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

                                  /*if (_formKey.currentState!.validate()) {
                                    _addComment(post.boardId!, post.id!,
                                        commentText);

                                    _commentTextEditController.clear();
                                    _commentFocusNode.unfocus();

                                    if (post.userId != authUserId) {
                                      _addNotification(
                                          post.title!,
                                          commentText,
                                          post.id!,
                                          post.userId!);
                                    }
                                  } else {
                                    null;
                                  }*/
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
}


