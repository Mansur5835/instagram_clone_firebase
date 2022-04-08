import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/port.dart';
import '../models/post_ui.dart';
import '../models/user.dart';
import '../services/auth_fribase.dart';
import '../services/firestore.dart';
import '../services/prefs.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({Key? key}) : super(key: key);

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  List<Post> list = [];
  String? id;
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('users').snapshots();

  Future getUser() async {
    id = await Prefs.getId();

    final map = await FirebaseServices.getUser(id!);

    final _map = map as Map<String, dynamic>;
    print(_map);
    User user = User.fromJson(_map);
    print("-1-1-1-1-" + "${user}");

    if (user != null) {
      return user;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Likes",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 25),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error no data"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Post> listP = [];
            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot document = snapshot.data!.docs[i];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              for (var j = 0; j < data['likedPosts'].length; j++) {
                listP.add(Post.fromJson(data['likedPosts'][j]));
              }
            }

            list = listP;

            if (list.isEmpty) {
              return Center(
                child: Text("No posts"),
              );
            }

            return ListView(
              children: List.generate(list.length, (index) {
                return PostUI(
                  isFavorite: true,
                  post: list[index],
                  favoriteFunc: () async {
                    User user = await getUser();

                    list.remove(list[index]);

                    user.likedPosts = list;

                    await AppFirestore.creadLikedPost(user, id!);

                    setState(() {});
                  },
                  sendFunc: () {},
                );
              }),
            );
          }),
    );
  }
}
