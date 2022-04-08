import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/pages/user_prifile.dart';
import 'port.dart';

class PostUI extends StatefulWidget {
  Post post;
  Map? map;

  bool isFavorite;
  final favoriteFunc;
  final sendFunc;
  bool isProfile;

  PostUI({
    Key? key,
    this.map,
    this.isProfile = false,
    required this.post,
    this.isFavorite = false,
    required this.favoriteFunc,
    required this.sendFunc,
  }) : super(key: key);

  @override
  State<PostUI> createState() => _PostUIState();
}

class _PostUIState extends State<PostUI> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            !widget.isProfile
                ? Container(
                    color: Colors.black,
                    child: ListTile(
                      leading: GestureDetector(
                          onTap: () {
                            if (widget.map != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
                                return UserProfile(
                                  map: widget.map!,
                                );
                              }));
                            }
                          },
                          child:
                              userImage(widget.post.profileImage.toString())),
                      contentPadding:
                          EdgeInsetsDirectional.only(start: 8, end: 0),
                      minLeadingWidth: 0,
                      title: Text(
                        widget.post.userName!,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            if (Platform.isAndroid) {
                              _showAndroidDialog(widget.post.userName!,
                                  widget.post.descreption!);
                            } else {
                              _showIosDialog(widget.post.userName!,
                                  widget.post.descreption!);
                            }
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          )),
                    ),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 0, end: 0),
              child: CachedNetworkImage(
                imageUrl: widget.post.image.toString(),
                placeholder: (b, w) {
                  return Container(
                    height: 350,
                    color: Colors.grey.shade400,
                    child: Icon(
                      Icons.image_outlined,
                      color: Colors.red,
                    ),
                  );
                },
                errorWidget: (v, e, d) {
                  return Container(
                    height: 350,
                    color: Colors.grey.shade400,
                    child: Icon(
                      Icons.error,
                      size: 40,
                      color: Colors.red,
                    ),
                  );
                },
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                height: 30,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });

                        widget.favoriteFunc();
                      },
                      icon: isFavorite || widget.isFavorite
                          ? Icon(
                              Icons.favorite_outlined,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: widget.sendFunc,
                      icon: Icon(
                        Icons.share,
                        color: Colors.grey,
                      ),
                    )
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 15),
              child: Text(
                widget.post.descreption!,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
              child: Text(
                widget.post.dateTime.toString().substring(0, 10),
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }

  Container userImage(String image) {
    print(image);
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          width: 50,
          height: 50,
          imageUrl: image,
          fit: BoxFit.cover,
          errorWidget: (w, e, d) {
            return userNoImage();
          },
          placeholder: (e, g) {
            return userNoImage();
          },
        ),
      ),
    );
  }

  _showAndroidDialog(String title, String massage) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(massage),
            actions: [
              TextButton(onPressed: () {}, child: Text("Delete")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  _showIosDialog(String title, String massage) {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(massage),
            actions: [
              TextButton(onPressed: () {}, child: Text("Delete")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  Container userNoImage() {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 50,
      child: Icon(
        Icons.person,
        color: Colors.white,
        size: 35,
      ),
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
    );
  }
}
