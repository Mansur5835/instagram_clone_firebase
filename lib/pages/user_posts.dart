import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/port.dart';
import 'package:instagram_flutter/models/post_ui.dart';
import 'package:instagram_flutter/services/firestore.dart';
import '../models/user.dart';
import '../services/auth_fribase.dart';
import '../services/prefs.dart';

class UserPosts extends StatefulWidget {
  UserPosts({
    Key? key,
  }) : super(key: key);

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  User? _user;
  List<Post> list = [];
  List<Post> listLiked = [];
  List<Map> listUser = [];
  List<int> userCount = [];
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
      _user = user;

      setState(() {});

      return user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Instagram",
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
            List<Post> listL = [];
            List<Map> listU = [];
            List<int> userC = [];

            Map map = {};

            for (var i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot document = snapshot.data!.docs[i];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              map = {
                'id': document.id,
                'name': data['name'],
                'posts': data['posts'],
                'profileImage': data['profileImage'],
                'followers': data['followers'],
                'folowing': data['folowing'],
              };

              listU.add(map);

              for (var j = 0; j < data['posts'].length; j++) {
                listP.add(Post.fromJson(data['posts'][j]));
                userC.add(i);
              }

              for (var j = 0; j < data['likedPosts'].length; j++) {
                listL.add(Post.fromJson(data['likedPosts'][j]));
              }
            }

            list = listP;
            listLiked = listL;
            listUser = listU;
            userCount = userC;

            if (list.isEmpty) {
              return Center(
                child: Text("No posts"),
              );
            }

            return ListView(children: [
              _user != null
                  ? Container(
                      height: _user!.folowing!.isEmpty ? 0 : 90,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(_user!.folowing!.length, (index) {
                          print("----${_user!.folowing![index]}");
                          return Followers(
                            id: _user!.folowing![index],
                          );
                        }),
                      ),
                    )
                  : SizedBox.shrink(),
              ...List.generate(list.length, (index) {
                if (listLiked.contains(list[index])) {
                  return PostUI(
                    post: list[index],
                    map: listUser[userCount[index]],
                    isFavorite: true,
                    favoriteFunc: () async {
                      User user = await getUser();

                      listLiked.remove(list[index]);

                      user.likedPosts =
                          List.generate(listLiked.length, (index) {
                        return listLiked[index].toJson();
                      });

                      await AppFirestore.creadLikedPost(user, id!);

                      setState(() {});
                    },
                    sendFunc: () {},
                  );
                }

                return PostUI(
                  post: list[index],
                  map: listUser[userCount[index]],
                  favoriteFunc: () async {
                    User user = await getUser();
                    listLiked.add(list[index]);

                    user.likedPosts = List.generate(listLiked.length, (index) {
                      return listLiked[index].toJson();
                    });

                    await AppFirestore.creadLikedPost(user, id!);

                    setState(() {});
                  },
                  sendFunc: () {},
                );
              }),
            ]);
          }),
    );
  }
}

class Followers extends StatefulWidget {
  String? id;

  Followers({Key? key, required this.id}) : super(key: key);

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  Map<String, dynamic>? map;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMap();
  }

  loadMap() async {
    map = await FirebaseServices.getUser(widget.id!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            width: 60,
            height: 60,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2, color: Colors.deepPurpleAccent.shade700),
                color: Colors.black,
                borderRadius: BorderRadius.circular(35)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl:
                      map != null ? map!['profileImage'].toString() : "bjk",
                  fit: BoxFit.cover,
                  errorWidget: (c, w, s) {
                    return addImageProfile();
                  },
                  placeholder: (w, b) {
                    return addImageProfile();
                  },
                ))),
        SizedBox(
          height: 8,
        ),
        map != null
            ? Container(
                alignment: Alignment.center,
                width: 50,
                child: Text(
                  map!['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              )
            : Container(),
      ],
    );
  }

  addImageProfile() {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Container(
            alignment: Alignment(0, 0),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(255, 253, 81, 224),
                        Colors.deepPurpleAccent.shade700,
                        Color.fromARGB(255, 255, 175, 242)
                      ])),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color.fromARGB(255, 253, 81, 224),
                          Colors.deepPurpleAccent.shade700,
                          Color.fromARGB(255, 255, 175, 242)
                        ])),
                width: 50,
                height: 50,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
