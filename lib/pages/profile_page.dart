import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/port.dart';
import 'package:instagram_flutter/models/post_ui.dart';
import 'package:instagram_flutter/pages/sign_up_page.dart';
import '../models/user.dart';
import '../services/auth_fribase.dart';
import '../services/firebase_storage.dart';
import '../services/firestore.dart';
import '../services/prefs.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? file;
  UploadTask? uploadTask;
  String? fileName;
  String? id;
  User? _user;

  Future uploadImage() async {
    if (file == null) return null;

    uploadTask = await FirebaseApi.uploadFile(file!.path, fileName!);

    final uplo = await uploadTask!.whenComplete(() => null);
    final urlD = await uplo.ref.getDownloadURL();

    print("=========== $urlD");
    return urlD;
  }

  _imageCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      file = File(image.path);
      fileName = image.name;
      await creatProfile();
    }

    setState(() {});
  }

  _imageGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      file = File(image.path);
      fileName = image.name;
      await creatProfile();
    }

    setState(() {});
  }

  Future getUser() async {
    id = await Prefs.getId();

    final map = await FirebaseServices.getUser(id!);

    final _map = map as Map<String, dynamic>;
    print(_map);
    User user = User.fromJson(_map);

    if (user != null) {
      return user;
    }

    return null;
  }

  creatProfile() async {
    User user = await getUser();

    await uploadImage().then((url) async {
      if (url != null) {
        user.profileImage = url;

        await AppFirestore.creadProfileImg(user, id!);
      }
    });
  }

  _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (c) {
          return Container(
            height: 100,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _imageGallery();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: Icon(
                    Icons.photo_size_select_actual,
                    color: Colors.grey.shade700,
                  ),
                  label: Text(
                    "Pick photo",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _imageCamera();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  icon: Icon(
                    Icons.photo_camera,
                    color: Colors.grey.shade700,
                  ),
                  label: Text(
                    "Take photo",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser().then((user) {
      if (user != null) {
        _user = user;
        setState(() {});
        print("--------${_user!.profileImage}");
      }
    });
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
          "Profile",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                creatProfile();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (c) {
                  return SignUp();
                }));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: _user != null
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    imageProfile(),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      _user!.name,
                      style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 21),
                    ),
                    Text(
                      _user!.email,
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _user!.posts!.length.toString(),
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "Posts",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Color.fromARGB(255, 177, 177, 177),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _user!.followers!.length.toString(),
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "Followers",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Container(
                          height: 30,
                          width: 1,
                          color: Color.fromARGB(255, 177, 177, 177),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _user!.folowing!.length.toString(),
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Text(
                              "Following",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ...List.generate(_user!.posts!.length, (index) {
                      return PostUI(
                          isProfile: true,
                          post: Post.fromJson(_user!.posts![index]),
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
                        imageUrl: _user != null
                            ? _user!.profileImage.toString()
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
          Container(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 44, 0, 240),
                radius: 10,
                child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: _showBottomSheet,
                    icon: Icon(
                      Icons.add,
                      size: 10,
                    ))),
          )
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
                  Icons.person,
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
