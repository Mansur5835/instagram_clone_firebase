import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/pages/likes_page.dart';
import 'package:instagram_flutter/pages/user_posts.dart';

import '../services/notification.dart';
import 'add_post_pagr.dart';
import 'profile_page.dart';
import 'search_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _initNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message: ${message.notification.toString()}");
      Notfcation.showLocalNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Notfcation.showLocalNotification(message);
    });
  }

  PageController _controller = PageController(initialPage: 0);
  int _seleckIndex = 0;

  @override
  void initState() {
    // TODO: implement initState

    _initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            _seleckIndex = index;
          });
        },
        children: [
          UserPosts(),
          SearchPage(),
          AppPost(controller: _controller),
          LikesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        iconSize: 26,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurpleAccent.shade700,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          _controller.jumpToPage(index);
        },
        currentIndex: _seleckIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
