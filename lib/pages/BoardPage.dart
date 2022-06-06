import 'package:flutter/material.dart';

import '../boards/Free_board.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: InkWell(
                    onTap: ()async{
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                            return Free_board();
                          }),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black,width: 3),
                      ),
                      child: Center(
                        child: Text(
                          '자유 게시판',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: InkWell(
                    onTap: ()async{
                      print('헬스');
                    },
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black,width: 3),
                      ),
                      child: Center(
                        child: Text(
                          '헬스 게시판',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Text('Board'),
            ],
          ),
        )
    );
  }
}
