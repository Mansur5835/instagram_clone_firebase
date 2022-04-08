class Post {
  late String? descreption;
  late String? dateTime;
  late String? userName;
  String? image;
  late String? profileImage;
  late int likesCount = 0;

  Post({
    required this.descreption,
    required this.userName,
    required this.dateTime,
    required this.image,
    required this.profileImage,
  });

  Post.fromJson(Map<String, dynamic> map) {
    descreption = map['descreption'];
    dateTime = map['dateTime'];
    userName = map['userName'];
    image = map['image'];
    profileImage = map['profileImage'];
  }

  Map<String, dynamic> toJson() {
    return {
      'descreption': descreption,
      'userName': userName,
      'dateTime': dateTime,
      'image': image,
      'profileImage': profileImage,
    };
  }

  bool operator ==(Object object) {
    return (object is Post) &&
        (userName == object.userName) &&
        (dateTime == object.dateTime);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$descreption $userName $image ";
  }
}
