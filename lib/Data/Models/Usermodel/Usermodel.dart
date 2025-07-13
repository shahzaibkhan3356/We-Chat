class UserModel {
  final String uid;
  final String name;
  final String email;
  final String number;
  final String bio;
  final String profilePic;
  final String statusurl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.number,
    this.bio = '',
    this.profilePic = '',
    this.statusurl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'number': number,
      'bio': bio,
      'profilePic': profilePic,
      'statusurl': statusurl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      number: map['number'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      statusurl: map['statusurl'] ?? '',
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? number,
    String? bio,
    String? profilePic,
    String? statusurl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      statusurl: statusurl ?? this.statusurl,
    );
  }
}
