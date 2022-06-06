class comment{
  String? author;
  String? content;
  String? date;
  String? time;
  String? id;

  comment();

  Map<String, dynamic> toJson() => {'작성자': author, '내용': content, '날짜': date,'시간': time};

  comment.fromSnapshot(snapshot,String id)
      :author = snapshot.data()['작성자'],
        content = snapshot.data()['내용'],
        date = snapshot.data()['날짜'],
        time = snapshot.data()['시간'],
        this.id = id;

}