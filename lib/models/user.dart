class User {
  String? id;
  late String name;
  late String password;
  late String email;

  late String? device_id;
  late String? device_type;
  late String? device_token;

  List<dynamic>? posts;
  List<dynamic>? likedPosts;
  List<dynamic>? followers;
  List<dynamic>? folowing;
  late String? profileImage;

  User({
    this.id,
    this.posts,
    required this.name,
    required this.email,
    required this.password,
    this.device_id,
    this.device_type,
    this.device_token,
    this.profileImage,
    this.likedPosts,
    this.followers,
    this.folowing,
  });

  User.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    password = map['password'];
    email = map['email'];
    posts = map['posts'];
    profileImage = map['profileImage'];
    likedPosts = map['likedPosts'];
    followers = map['followers'];
    folowing = map['folowing'];

    device_id = map['device_id'];
    device_type = map['device_type'];
    device_token = map['device_token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'posts': posts,
      'profileImage': profileImage,
      'likedPosts': likedPosts,
      'followers': followers,
      'folowing': folowing,
      'device_id': device_id,
      'device_type': device_type,
      'device_token': device_token,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$posts   $email $password";
  }
}
