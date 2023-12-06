class UserModel{
  String name;
  String email;
  String bio;
  String profilPic;
  String createdAt;
  String phoneNumber;
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.bio,
    required this.profilPic,
    required this.createdAt,
    required this.phoneNumber,
    required this.uid,
  });

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
        name: map['name'] ?? '',
        email: map['email'] ?? '',
        bio: map['bio'] ?? '',
        profilPic: map['profilPic'] ?? '',
        createdAt: map['createdAt'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        uid: map['uid'] ?? ''
    );
  }

  Map<String, dynamic> toMap(){
    return{
      "name": name,
      "email": email,
      "bio": bio,
      "profilPic": profilPic,
      "createdAt": createdAt,
      "phoneNumber": phoneNumber,
      "uid": uid,
    };
  }
}