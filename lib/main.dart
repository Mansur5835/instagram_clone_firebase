import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagram_flutter/pages/sign_up_page.dart';
import 'package:instagram_flutter/services/prefs.dart';

import 'pages/sign_in_page.dart';

String? _id;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getUser();
  await _initNotification();

  var initAndroidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = const IOSInitializationSettings();
  var initSetting =
      InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(App());
  });
}

// void _openSignInPage() => Timer(
//     const Duration(seconds: 2),
//     () => Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => _starterPage())));
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

_initNotification() async {
  await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await _firebaseMessaging.getToken().then((token) async {
    if (kDebugMode) {
      print(token);
    }
    await Prefs.saveToken(token!);
  });
}

// @override
// void initState() {
//   // super.initState();
//   _openSignInPage();
//   _initNotification();
// }

getUser() async {
  await Prefs.getId().then((id) {
    if (id != null) {
      print(id);
      _id = id;
    }
  });
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Text(
          "Instagram",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 40),
        ),
        nextScreen: _id != null
            ? SignIn(
                id: _id,
              )
            : SignUp(),
        backgroundColor: Colors.deepPurpleAccent.shade700,
        splashTransition: SplashTransition.rotationTransition,
      ),
    );
  }
}
