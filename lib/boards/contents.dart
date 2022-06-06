class contents{
  String? title;
  String? content;
  String? date;
  String? write;
  String? time;

  contents();

  Map<String, dynamic> toJson() => {'제목': title, '내용': content, '날짜': date, '작성자': write, '시간': time};

  contents.fromSnapshot(snapshot)
    :title = snapshot.data()['제목'],
    content = snapshot.data()['내용'],
    date = snapshot.data()['날짜'],
    write = snapshot.data()['작성자'],
    time = snapshot.data()['시간'];
}