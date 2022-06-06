import 'package:flutter/material.dart';
import 'package:health/boards/comment.dart';

class commentcard extends StatelessWidget {
  final comment commentlist;

  commentcard(this.commentlist);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Color(0xffE6E6E6),
              child: Icon(
                Icons.comment,
                color: Color(0xffCCCCCC),
              ),
            ),
          ),
          title: Text(
            commentlist.author!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            commentlist.content!,
          ),
          trailing: Text(
            commentlist.date!,
          ),
        ),
    ],
    );
  }
}
