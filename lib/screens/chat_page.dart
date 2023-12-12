import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';

class ChatPage extends StatefulWidget {
  String uid;
  String name;
  ChatPage({Key? key, required this.uid, required this.name}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messegeController = TextEditingController();
  String documentPath = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _alredyExists();
    if (kDebugMode) {
      print(documentPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.name,
        style: buildPoppinsTextStyle(),
      )),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: documentPath == ''
                  ? Container()
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(documentPath)
                          .collection('messeges')
                          .orderBy("Time", descending: false)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshots) {
                        return snapshots.hasData
                            ? ListView.builder(
                                reverse: true,
                                itemCount: snapshots.data?.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshots
                                      .data?.docs.reversed //Have A Look Here.
                                      .toList()[index];
                                  return MessegeCard(
                                    // sender: data!['sender'],
                                    sender: data!['Sender'],
                                    text: data['messege'],
                                  );
                                },
                              )
                            : const Center(child: CircularProgressIndicator());
                      }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: MediaQuery.of(context).size.width > webScreenSize
                    ? EdgeInsets.symmetric(
                        horizontal: width > webScreenSize
                            ? width * 0.2
                            : width > 700
                                ? width * 0.3
                                : 0,
                      )
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black26,
                ),
                height: 50,
                width: MediaQuery.of(context).size.width - 16,
                child: TextField(
                  controller: messegeController,
                  onSubmitted: (a) {
                    mahesh(a);
                    messegeController.clear();
                  },
                  decoration: const InputDecoration(
                      hintText: ' Messege Here.........',
                      border: OutlineInputBorder()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  mahesh(a) async {
    if (documentPath == '') {
      Map<String, dynamic> users = {
        'users': [
          FirebaseAuth.instance.currentUser?.uid,
          widget.uid,
        ],
      };
      await FirebaseFirestore.instance
          .collection('rooms')
          .add(users)
          .then((value) => documentPath = value.id);
    }
    Map<String, dynamic> messege = {
      'messege': messegeController.text.trim(),
      'Sender': FirebaseAuth.instance.currentUser?.uid,
      'Receiver': widget.uid,
      'Time': DateTime.now()
    };
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(documentPath)
        .collection('messeges')
        .add(messege)
        .then((value) {
      _alredyExists();
    });
  }

  _alredyExists() async {
    await FirebaseFirestore.instance.collection('rooms').get().then((value) {
      value.docs.forEach((element) {
        List d = element['users'];
        if (d.contains(FirebaseAuth.instance.currentUser?.uid) &&
            d.contains(widget.uid)) {
          setState(() {
            documentPath = element.id;
          });
        }
      });
    });
  }
}

class MessegeCard extends StatelessWidget {
  String text;
  String sender;

  MessegeCard({Key? key, required this.text, required this.sender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (FirebaseAuth.instance.currentUser!.uid == sender) Spacer(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 10,
            ),
            /*margin: const EdgeInsets.all(11),
            color: FirebaseAuth.instance.currentUser!.uid != sender
                ? Colors.black54
                : Colors.blue[300],*/
            child: Padding(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: width > webScreenSize
                          ? width * 0.2
                          : width > 700
                              ? width * 0.3
                              : 0,
                      vertical: width > webScreenSize ? 2 : 0,
                    )
                  : EdgeInsets.zero,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: FirebaseAuth.instance.currentUser?.uid == sender
                      ? Colors.grey
                      : Colors.blue[300],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: text,
                          style: buildMontserratTextStyle()
                              .copyWith(fontSize: 19, color: Colors.white),
                        ),
                      ),
                    ],
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
