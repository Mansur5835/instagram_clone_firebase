import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/port.dart';
import 'package:instagram_flutter/models/user.dart';

import '../services/auth_fribase.dart';
import '../services/firebase_storage.dart';
import '../services/firestore.dart';
import '../services/prefs.dart';

class AppPost extends StatefulWidget {
  PageController controller;

  AppPost({Key? key, required this.controller}) : super(key: key);

  @override
  State<AppPost> createState() => _AppPostState();
}

class _AppPostState extends State<AppPost> {
  File? file;
  String? fileName;
  UploadTask? uploadTask;
  TextEditingController _caption = TextEditingController();
  String? id;
  bool isLoad = false;

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
    }

    setState(() {});
  }

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

  creatPost() async {
    var user = await getUser();

    print("============$user");

    await uploadImage().then((url) async {
      print("========l=l==l=$url");

      if (url != null) {
        Post post = Post(
            descreption: _caption.text.toString(),
            userName: user!.name,
            dateTime: DateTime.now().toString(),
            image: url,
            profileImage: user.profileImage);

        user.posts!.add(post.toJson());
        await AppFirestore.creadPost(user, id!);
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Upload",
          style: TextStyle(
              fontFamily: "Billabong", color: Colors.white, fontSize: 25),
        ),
        actions: [
          isLoad
              ? Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.purpleAccent.shade700,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          IconButton(
              onPressed: () async {
                setState(() {
                  isLoad = true;
                });
                await creatPost();
                file = null;
                _caption.clear();
                widget.controller.jumpToPage(0);
                setState(() {
                  isLoad = false;
                });
              },
              icon: Icon(Icons.post_add, color: Colors.purpleAccent.shade700))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            file == null
                ? InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: _showBottomSheet,
                    child: Container(
                      color: Colors.grey.shade800,
                      height: MediaQuery.of(context).size.height / 2,
                      child: Icon(
                        Icons.add_a_photo,
                        size: 45,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(file!), fit: BoxFit.cover)),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                controller: _caption,
                decoration: InputDecoration(
                    hintText: "Caption",
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
