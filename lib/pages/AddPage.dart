
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddPage extends StatelessWidget {

  TextEditingController _DataTimeEditingController = TextEditingController();
  TextEditingController _EstimatedEditingController = TextEditingController();
  DateTime? tempPickedDate;

  TextEditingController date = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController food = TextEditingController();
  TextEditingController exercise = TextEditingController();
  TextEditingController height = TextEditingController();
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('기록 추가'),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 10)),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            _selectDataCalendar(context);
                          },
                          child: AbsorbPointer(
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding:
                              const EdgeInsets.only(right: 10, left: 10, top: 10),
                              child: TextFormField(
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  labelText: '날짜를 선택하세요',
                                  contentPadding: new EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return '날짜를 선택해 주세요.';
                                  }
                                  return null;
                                },
                                controller: _DataTimeEditingController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 25.0,right: 25.0,top: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '키를 입력하세요',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '키를 입력해 주세요.';
                      }
                      return null;
                    },
                    controller: height,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25.0,right: 25.0,top: 15.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '몸무게를 입력하세요',
                      contentPadding: new EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '몸무게를 입력해 주세요.';
                      }
                      return null;
                    },
                    controller: weight,
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(left: 25.0,right: 25.0,top: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '먹은 음식을 입력하세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '음식을 입력해 주세요.';
                      }
                      return null;
                    },
                    controller: food,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 25.0,right: 25.0,top: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '운동을 입력하세요',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '운동을 입력해 주세요.';
                      }
                      return null;
                    },
                    controller: exercise,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                  onPressed: () {
                    final user = _authentication.currentUser;
                    loggedUser = user;

                    String date = _DataTimeEditingController.text;
                    final isVaild = _formkey.currentState!.validate();
                    if(isVaild) {
                      int intweight = int.parse(weight.text);
                      double doubleheight = double.parse(height.text);
                      
                      double bmivalue = (intweight/((doubleheight / 100) * (doubleheight /100)));

                      FirebaseFirestore.instance.collection(loggedUser?.email as String).doc(date).set({
                        '키' : height.text,
                        '몸무게': weight.text,
                        '음식': food.text,
                        '운동': exercise.text,
                        '날짜': _DataTimeEditingController.text,
                        'bmi': bmivalue.toStringAsFixed(1),

                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text("추가"),

                ),



              ],
            ),
          ),
        )
    );
  }

  void _selectDataCalendar(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return SafeArea(
              child: Center(
                child: Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 1.1,
                  height: 550,
                  child: SfDateRangePicker(
                    monthViewSettings: DateRangePickerMonthViewSettings(
                      dayFormat: 'EEE',
                    ),
                    monthFormat: 'MMM',
                    showNavigationArrow: true,
                    headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontSize: 25, color: Colors.blue),
                    ),
                    headerHeight: 80,
                    view: DateRangePickerView.month,
                    allowViewNavigation: false,
                    backgroundColor: ThemeData
                        .light()
                        .scaffoldBackgroundColor,
                    initialSelectedDate: DateTime.now(),
                    //minDate: DateTime.now(),
                    // 아래코드는 tempPickedDate를 전역으로 받아 시작일을 선택한 날자로 시작할 수 있음
                    minDate: tempPickedDate,
                    //maxDate: DateTime.now().add(new Duration(days: 365)),
                    maxDate: tempPickedDate,
                    // 아래 코드는 선택시작일로부터 2주까지밖에 날자 선택이 안됌
                    //maxDate: tempPickedDate!.add(new Duration(days: 14)),
                    selectionMode: DateRangePickerSelectionMode.single,
                    confirmText: '완료',
                    cancelText: '취소',
                    onSubmit: (args) =>
                    {
                      _EstimatedEditingController.clear(),
                      //tempPickedDate = args as DateTime?;
                      _DataTimeEditingController.text = args.toString(),
                      convertDateTimeDisplay(
                          _DataTimeEditingController.text, '날짜'
                      ),
                      Navigator.of(context).pop(),
                    },
                    onCancel: () => Navigator.of(context).pop(),
                    showActionButtons: true,
                  ),
                ),
              ));
        });
  }

  String convertDateTimeDisplay(String date, String text) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    if (text == '날짜') {
      _EstimatedEditingController.clear();
      return _DataTimeEditingController.text =
          serverFormater.format(displayDate);
    } else
      return _EstimatedEditingController.text =
          serverFormater.format(displayDate);
  }

}
