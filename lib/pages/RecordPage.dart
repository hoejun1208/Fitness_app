import 'package:flutter/material.dart';
import 'package:health/screens/health_main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import './AddPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {

  final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String food = "";
  String exercise = "";
  bool exist = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2022),
                  lastDay: DateTime(2099),
                  locale: 'ko-KR',
                  daysOfWeekHeight: 20,
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronVisible: true,
                      rightChevronVisible: true
                  ),
                  calendarStyle: CalendarStyle(
                    weekendTextStyle: TextStyle().copyWith(color: Colors.red),

                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      final user = _authentication.currentUser;
                      loggedUser = user;


                      print(loggedUser?.email as String);
                      print(serverFormater.format(focusedDay));
                      FirebaseFirestore.instance.collection(loggedUser?.email as String).doc(serverFormater.format(focusedDay)).get()
                          .then((DocumentSnapshot ds) {

                            if(ds.exists) {
                              Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
                              food = data['음식'];
                              exercise = data['운동'];
                              exist = true;
                            }else{
                              exist = false;
                            }


                      });
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },

                ),
                SizedBox(height: 0.0,),
                Text(
                  ' 먹은 음식',
                  style: TextStyle(
                      color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0
                  ),
                ),

                if(exist == true)
                  Text(
                    food,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                 if(exist == false)
                  Text(
                      '추가하세요!',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                SizedBox(height: 20.0,),

                Text(
                    '  운동',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),),
                if(exist == true)
                  Text(
                      exercise,
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),

                  ),
                if(exist == false)
                  Text(
                      '추가하세요!',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),


                Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 30,
                    child: IconButton(
                      iconSize: 30,
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add),
                      onPressed: ()async{
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context){
                          return AddPage();
                        }),
                        );
                      },
                    ),
                  ),
                ),
              ],

            ),
      ),
        );
  }
}
