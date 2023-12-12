import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/screens/login_screen.dart';
import 'package:instagram_clone_flutter/screens/profile_screen.dart';
import 'package:instagram_clone_flutter/utils/global_variable.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            'Search Friends',
            style: buildPoppinsTextStyle()
                .copyWith(fontSize: 21, fontWeight: FontWeight.bold),
          )),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SearchFriends(),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchFriends extends StatefulWidget {
  const SearchFriends({Key? key}) : super(key: key);

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
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
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize
                    ? width * 0.2
                    : width > 700
                        ? width * 0.3
                        : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black26,
              ),
              height: 55,
              child: Center(
                child: TextField(
                  focusNode: myfocusnode,
                  onTap: () {
                    setState(() {});
                  },
                  onSubmitted: (a) {
                    setState(() {});
                  },
                  onChanged: (a) {
                    setState(() {
                      query = a;
                    });
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search Friend Here..........'),
                ),
              ),
            ),
          ),
          if (myfocusnode.hasFocus)
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: ((context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data?.docs
                                .where((element) =>
                                    element.id !=
                                        FirebaseAuth
                                            .instance.currentUser?.uid &&
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
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          uid: data![index]['uid']),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: MediaQuery.of(context).size.width >
                                          webScreenSize
                                      ? EdgeInsets.symmetric(
                                          horizontal: width > webScreenSize
                                              ? width * 0.2
                                              : width > 700
                                                  ? width * 0.3
                                                  : 0,
                                          vertical:
                                              width > webScreenSize ? 7 : 0,
                                        )
                                      : const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    tileColor: Colors.white10,
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        data![index]['photoUrl'],
                                      ),
                                      radius: 16,
                                    ),
                                    title: Text(
                                      data[index]['username'],
                                      style: buildMontserratTextStyle()
                                          .copyWith(fontSize: 19),
                                    ),
                                  ),
                                ),
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
