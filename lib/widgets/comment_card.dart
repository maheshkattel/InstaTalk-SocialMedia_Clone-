import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap.data()['name'],
                            style: buildMontserratTextStyle(
                                    fontWeight: FontWeight.bold)
                                .copyWith(fontSize: 19, color: Colors.white)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '${snap.data()['text']}',
                            style: buildMontserratTextStyle()
                                .copyWith(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                        DateFormat.yMMMd().format(
                          snap.data()['datePublished'].toDate(),
                        ),
                        style: buildMontserratTextStyle().copyWith(
                            fontSize: 13, color: Colors.grey.shade600)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
