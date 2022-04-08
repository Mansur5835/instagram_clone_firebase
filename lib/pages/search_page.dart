import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/user.dart';
import '../services/auth_fribase.dart';
import '../services/firestore.dart';
import '../services/prefs.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String onChang = '';
  List<Map<dynamic, dynamic>> listUserName = [];
  final _usersDoc = FirebaseFirestore.instance.collection('users').snapshots();

  String? id;
  User? _user;
  Future getUser() async {
    id = await Prefs.getId();
    setState(() {});

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

    return null;
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
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 25),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 45,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              onChanged: (val) {
                onChang = val.trim();
                listUserName.clear();

                setState(() {});
              },
              decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white70),
                  icon: Icon(Icons.search, color: Colors.white70),
                  border: InputBorder.none),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _usersDoc,
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

            List<Map<dynamic, dynamic>> listU = [];

            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot document = snapshot.data!.docs[i];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Map map = {};

              if (data['name'].toString().contains(onChang) ||
                  data['name'].toString().startsWith(onChang)) {
                map = {
                  'id': document.id,
                  'name': data['name'],
                  'email': data['email'],
                  'posts': data['posts'],
                  'profileImage': data['profileImage'],
                  'followers': data['followers'],
                  'folowing': data['folowing'],
                };

                listU.add(map);
              }
            }

            listUserName = listU;

            if (listUserName.isEmpty) {
              return Center(
                child: Text("No users"),
              );
            }

            return ListView(
              children: List.generate(listUserName.length, (index) {
                return followUi(listUserName[index]);
              }),
            );
          }),
    );
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

  followUi(Map<dynamic, dynamic> map) {
    return ListTile(
      title: Container(
        // color: Colors.red,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(400),
            child: CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: map['profileImage'].toString(),
              fit: BoxFit.cover,
              errorWidget: (w, e, d) {
                return userNoImage();
              },
              placeholder: (e, g) {
                return userNoImage();
              },
            ),
          ),
          contentPadding: EdgeInsetsDirectional.zero,
          minLeadingWidth: 0,
          title: Text(
            map['name'].toString(),
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          subtitle: Text(
            map['email'].toString(),
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.blueAccent, width: 2)),
            child: TextButton(
              onPressed: () async {
                User user = await getUser();

                if (map['followers'].contains(id.toString())) {
                  user.folowing!.remove(map['id']);

                  await AppFirestore.deleteFollowing(
                      id!, user, map['followers'], map['id']);
                  setState(() {});
                  return;
                }

                user.folowing!.add(map['id']);

                await AppFirestore.creatFollowing(
                    id!, user, map['followers'], map['id']);
                setState(() {});
              },
              style: ButtonStyle(),
              child: Text(map['followers'].contains(id.toString())
                  ? "Unfollow"
                  : "Follow"),
            ),
          ),
        ),
      ),
    );
  }
}
