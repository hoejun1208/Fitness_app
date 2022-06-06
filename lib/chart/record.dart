class record{
  String? weight;
  String? date;

  record();

  Map<String,dynamic> toJson() => {'몸무게':weight,'날짜':date};

  record.fromSnapshot(snapshot)
    :weight = snapshot.data()['몸무게'],
    date = snapshot.data()['날짜'];
}