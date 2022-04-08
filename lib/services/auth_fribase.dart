import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/user.dart';

class FirebaseServices {
  static Future<String?> creadUser(
      String name, String email, String password, Map map) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc();

    final user = User(
        name: name,
        email: email,
        password: password,
        device_id: map['device_id'],
        device_token: map['device_token'],
        device_type: map['device_type'],
        posts: [],
        likedPosts: [],
        followers: [],
        folowing: []);
    await _usersDoc.set(user.toJson());
    print(_usersDoc.id);
    return _usersDoc.id;
  }

  static Future<Map<String, dynamic>?> getUser(String id) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);

    final map = await _usersDoc.get();
    print(map.data());
    if (map.data() != null) {
      return map.data();
    }

    return null;
  }
}
