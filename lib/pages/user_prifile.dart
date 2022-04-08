import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/port.dart';
import 'package:instagram_flutter/models/post_ui.dart';
import 'package:instagram_flutter/models/user.dart';

import '../services/auth_fribase.dart';
import '../services/firestore.dart';
import '../services/prefs.dart';

class UserProfile extends StatefulWidget {
  Map map;
  UserProfile({Key? key, required this.map}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? id;

  Future getUser() async {
    id = await Prefs.getId();
    setState(() {});

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
  void initState() {
    // TODO: implement initState
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: Colors.white,
            )),
        backgroundColor: Colors.black,
        title: Text(
          widget.map['name'],
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 25),
        ),
      ),
      body: widget.map != null
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        imageProfile(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.map['posts'].length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text("Posts"),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.map['followers'].length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text("Followers"),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Color.fromARGB(255, 163, 163, 163),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.map['folowing'].length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text("Following"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            User user = await getUser();

                            if (widget.map['followers']
                                .contains(id.toString())) {
                              user.folowing!.remove(widget.map['id']);

                              await AppFirestore.deleteFollowing(id!, user,
                                  widget.map['followers'], widget.map['id']);
                              setState(() {});
                              return;
                            }

                            user.folowing!.add(widget.map['id']);

                            await AppFirestore.creatFollowing(id!, user,
                                widget.map['followers'], widget.map['id']);
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,

                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 2, color: Colors.blueAccent)),
                            child: Text(
                              widget.map['followers'].contains(id.toString())
                                  ? "Unfollow"
                                  : "Following",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ...List.generate(widget.map['posts'].length, (index) {
                      return PostUI(
                          isProfile: true,
                          post: Post.fromJson(widget.map['posts'][index]),
                          favoriteFunc: () {},
                          sendFunc: () {});
                    }),
                    SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  imageProfile() {
    return Container(
      width: 83,
      height: 83,
      child: Stack(
        children: [
          Container(
            alignment: Alignment(0, 0),
            child: Container(
              alignment: Alignment.center,
              height: 85,
              width: 85,
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
                  height: 80,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.white, width: 2)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: CachedNetworkImage(
                        height: 80,
                        width: 80,
                        imageUrl: widget.map != null
                            ? widget.map['profileImage'].toString()
                            : "bjk",
                        fit: BoxFit.cover,
                        errorWidget: (c, w, s) {
                          return addImageProfile();
                        },
                        placeholder: (w, b) {
                          return addImageProfile();
                        },
                      ))),
            ),
          ),
        ],
      ),
    );
  }

  addImageProfile() {
    return Container(
      width: 83,
      height: 83,
      child: Stack(
        children: [
          Container(
            alignment: Alignment(0, 0),
            child: Container(
              alignment: Alignment.center,
              height: 82,
              width: 82,
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
                width: 80,
                height: 80,
                child: Icon(
                  Icons.person_outline_sharp,
                  size: 40,
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
