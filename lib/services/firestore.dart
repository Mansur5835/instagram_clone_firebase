import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AppFirestore {
  static Future creatFollowing(
      String id, User user, List<dynamic> userFollowers, String userId) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);
    await _usersDoc.update({'folowing': user.folowing});

    userFollowers.add(id);

    await creatFollowers(userId, userFollowers);
  }

  static Future creatFollowers(String id, List<dynamic> userFollowers) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);

    await _usersDoc.update({'followers': userFollowers});
  }

  static Future deleteFollowing(
      String id, User user, List<dynamic> userFollowers, String userId) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);
    await _usersDoc.update({'folowing': user.folowing});

    userFollowers.remove(id);

    await deleteFollowers(userId, userFollowers);
  }

  static Future deleteFollowers(String id, List<dynamic> userFollowers) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);

    await _usersDoc.update({'followers': userFollowers});
  }

  static Future creadPost(User user, String id) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);
    await _usersDoc.update({'posts': user.posts});
  }

  static Future creadLikedPost(User user, String id) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);
    await _usersDoc.update({'likedPosts': user.likedPosts});
  }

  static Future creadProfileImg(User user, String id) async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc(id);
    await _usersDoc.update({'profileImage': user.profileImage});
  }

  static Future<Map<String, dynamic>?> getUserPosts() async {
    final _usersDoc = FirebaseFirestore.instance.collection('users').doc();

    final map = await _usersDoc.get();

    print(map.data());

    if (map.data() != null) {
      return map.data();
    }

    return null;
  }
}
