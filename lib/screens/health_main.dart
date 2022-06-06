
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/BoardPage.dart';
import '../pages/HomePage.dart';
import '../pages/RecordPage.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({Key? key}) : super(key: key);

  @override
  _HealthScreenState createState() => _HealthScreenState();

}

class _HealthScreenState extends State<HealthScreen> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  int _selectedindex =0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser(){
    try {
      final user = _authentication.currentUser;
      if (user != null) {
        loggedUser = user;
        print(loggedUser!.email);
      }
    }catch(e){
      print(e);
    }
  }
  List pages =[
    RecordPage(),
    HomePage(),
    BoardPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('health screen'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: (){
              _authentication.signOut();
              Navigator.pop(context);
            },)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedindex,
        onTap: (int index){
          setState(() {
            _selectedindex = index;
          });
        }, //onTap
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '게시판',
          ),
        ],
      ),
      body:  pages[_selectedindex]
      );
  }
}
