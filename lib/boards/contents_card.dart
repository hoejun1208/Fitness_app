import 'package:flutter/material.dart';
import 'package:health/boards/contents.dart';
import 'package:health/boards/contents_view.dart';

class contentscard extends StatelessWidget {
  final contents contentslist;

  contentscard(this.contentslist);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        contentslist.title!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        contentslist.content!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        contentslist.date!,
      ),
      onTap: () async{
       Navigator.push(context, MaterialPageRoute(builder: (context) => contents_view(contentslist: contentslist),
        ),
       );
      }
      );
  }
}
