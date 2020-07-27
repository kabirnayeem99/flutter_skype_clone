class User {
  User({
    this.uid,
    this.name,
    this.email,
    this.username,
    this.status,
    this.state,
    this.profilePhoto,
  });

  String uid;
  String name;
  String email;
  String username;
  String status;
  int state;
  String profilePhoto;

  Map toMap(User user) {
    /* archiving the user model into a map */
    var data = Map<String, dynamic>();
    data["uid"] = user.uid;
    data["name"] = user.name;
    data["email"] = user.email;
    data["username"] = user.username;
    data["status"] = user.status;
    data["state"] = user.state;
    data["profilePhoto"] = user.profilePhoto;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    /* retrieving the user model into a map */
    this.uid = mapData["uid"];
    this.name = mapData["name"];
    this.email = mapData["email"];
    this.username = mapData["username"];
    this.status = mapData["status"];
    this.state = mapData["state"];
    this.profilePhoto = mapData["profilePhoto"];
  }
}
