import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../chart/chart.dart';
import '../chart/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
 HomePageState createState() => HomePageState();
}



class HomePageState extends State<HomePage> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  List weight = [];
  List date = [];
  List bmi = [];
  List<dynamic> doubleweight = [];
  int minweight = 0;
  int maxweight = 0;
  double minbmi = 0.0;
  double maxbmi = 0.0;
  List<dynamic> doublebmi =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: getdata(),
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                  if (snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  }
                  //error가 발생하게 될 경우 반환하게 되는 부분
                  else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    );
                  }
                  // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                  else {
                    getweight();
                    getbmi();
                    return Container(
                      child: Column(
                        children: <Widget>[
                          Positioned(
                              child: Container(
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('image/ww.jpg'),
                                        fit: BoxFit.fill
                                    )
                                ),
                              )),
                          SizedBox(height: 10.0,),
                          Text('몸무게'),
                          Container(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 5/2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                  child: LineChart(
                                    weightChart(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text('bmi'),
                          Container(
                            height: 200,
                            child: AspectRatio(
                              aspectRatio: 5/2,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                  child: LineChart(
                                    bmiChart(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),
                    );
                  }
                }
            ),

          
        ]),
      ),
            ));

  }

  LineChartData weightChart() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitles: (value) {

            if(date.length>4){
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
                case 7:
                  return date[2];
                case 10:
                  return date[3];
                case 13:
                  return date[4];
              }
            }else if(date.length>3){
              switch (value.toInt()) {
                  case 1:
                    return date[0];
                  case 4:
                    return date[1];
                  case 7:
                    return date[2];
                  case 10:
                    return date[3];
              }
    }else if(date.length>2) {
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
                case 7:
                  return date[2];
              }
            }else if(date.length>1) {
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
              }
            }else if(date.isNotEmpty) {
              switch (value.toInt()) {
                case 1:
                  return date[0];

              }
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if(weight.isNotEmpty) {
              switch (value.toInt()) {
                case 0:
                  return minweight.toString();
                case 10:
                  return weight[0];
                case 19:
                  return maxweight.toString();
              }
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 19,
      lineBarsData: [

        LineChartBarData(
          spots: [
              FlSpot(1, doubleweight[0]),
              FlSpot(4, doubleweight[1]),
              FlSpot(7, doubleweight[2]),
              FlSpot(10, doubleweight[3]),
              FlSpot(13, doubleweight[4]),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData bmiChart() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTitles: (value) {

            if(date.length>4){
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
                case 7:
                  return date[2];
                case 10:
                  return date[3];
                case 13:
                  return date[4];
              }
            }else if(date.length>3){
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
                case 7:
                  return date[2];
                case 10:
                  return date[3];
              }
            }else if(date.length>2) {
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
                case 7:
                  return date[2];
              }
            }else if(date.length>1) {
              switch (value.toInt()) {
                case 1:
                  return date[0];
                case 4:
                  return date[1];
              }
            }else if(date.isNotEmpty) {
              switch (value.toInt()) {
                case 1:
                  return date[0];

              }
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {

            if(bmi.isNotEmpty) {
              switch (value.toInt()) {
                case 0:
                  return minbmi.toString();
                case 3:
                  return bmi[0];
                case 6:
                  return maxbmi.toString();
              }
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 14,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [

            FlSpot(1, doublebmi[0]),
            FlSpot(4, doublebmi[1]),
            FlSpot(7, doublebmi[2]),
            FlSpot(10, doublebmi[3]),
            FlSpot(13, doublebmi[4]),

          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
            gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),


      ],
    );
  }
  Future getdata() async{
      final user = _authentication.currentUser;
      loggedUser = user;
      await FirebaseFirestore.instance
          .collection(loggedUser?.email as String)
          .orderBy("날짜",descending: true)
          .limit(5)
          .get()
          .then((QuerySnapshot ds) {
        ds.docs.forEach((element) {weight.add(element['몸무게']); });
        ds.docs.forEach((element) {date.add(element['날짜']);});
        ds.docs.forEach((element) {bmi.add(element['bmi']); });
      });
      return '완료';
  }
  void getweight(){
    if(weight.isNotEmpty){

      minweight = int.parse(weight[0]) - 10;
      maxweight = int.parse(weight[0]) + 10;
      for(int i=0;i<weight.length;i++) {
        double dw = double.parse(weight[i])-minweight;
        doubleweight.add(dw);
      }if(weight.length<5){
        for(int i = weight.length; i<5;i++){
          double dw = 0.0;
          doubleweight.add(dw);
        }
      }
    }else{
      for(int i=0;i<5;i++) {
        double dw = 0.0;
        doubleweight.add(dw);
      }
    }
  }
  void getbmi(){
    if(bmi.isNotEmpty){

      minbmi = double.parse(bmi[0]) - 3.0;
      maxbmi = double.parse(bmi[0]) + 3.0;
      for(int i=0;i<bmi.length;i++) {
        double db = double.parse(bmi[i])-minbmi;
        doublebmi.add(db);
      }if(bmi.length<5){
        for(int i = bmi.length; i<5;i++){
          double db = 0.0;
          doublebmi.add(db);
        }
      }
    }else{
      for(int i=0;i<5;i++) {
        double db = 0.0;
        doublebmi.add(db);
      }
    }
  }

}
