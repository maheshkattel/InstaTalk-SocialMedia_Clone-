import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/chat_page.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';

class MessegePage extends StatefulWidget {
  const MessegePage({Key? key}) : super(key: key);

  @override
  State<MessegePage> createState() => _MessegePageState();
}

class _MessegePageState extends State<MessegePage> {
  onTapp() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Messages',
            style: buildPoppinsTextStyle()
                .copyWith(fontSize: 21, fontWeight: FontWeight.bold),
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Friends(),
            ],
          ),
        ),
      ),
    );
  }
}

class Friends extends StatefulWidget {
  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  late FocusNode myfocusnode;
  String query = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myfocusnode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(
                      horizontal: width > webScreenSize
                          ? width * 0.2
                          : width > 700
                              ? width * 0.3
                              : 0,
                      vertical: width > webScreenSize ? 15 : 0,
                    )
                  : EdgeInsets.zero,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.black),
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: ((context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data?.docs
                              .where((element) =>
                                  element.id !=
                                      FirebaseAuth.instance.currentUser?.uid &&
                                  element['username']
                                      .toString()
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                              .length,
                          itemBuilder: ((context, index) {
                            var data = snapshot.data?.docs
                                .where((element) =>
                                    element.id !=
                                        FirebaseAuth
                                            .instance.currentUser?.uid &&
                                    element['username']
                                        .toString()
                                        .toLowerCase()
                                        .contains(query.toLowerCase()))
                                .toList();
                            return FriendsCard(
                              document: data![index],
                            );
                          }),
                        )
                      : Container();
                }),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class FriendsCard extends StatelessWidget {
  final QueryDocumentSnapshot document;
  const FriendsCard({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white10,
        ),
        child: ListTile(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return ChatPage(
                name: document['username'],
                uid: document.id,
              );
            })));
          },
          leading:
              CircleAvatar(backgroundImage: NetworkImage(document['photoUrl'])),
          title: Text(document['username'],
              style: buildMontserratTextStyle().copyWith(fontSize: 19)),
        ),
      ),
    );
  }
}
