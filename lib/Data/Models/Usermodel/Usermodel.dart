class UserModel {
  final String uid;
  final String email;
  final String statusurl;
  final String number;
  final String bio;
  final String profilePic;

  UserModel({
    required this.uid,
    required this.email,
    required this.number,
    this.bio = '',
    this.profilePic = '',
    this.statusurl=''
  });

  // Convert AppUser to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'statusurl':statusurl,
      'uid': uid,
      'email': email,
      'number': number,
      'bio': bio,
      'profilePic': profilePic,
    };
  }

  // Create AppUser from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      email: map['email'] ?? '',
      number: map['number'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      statusurl: map['statusurl'] ?? '',
    );
  }
}
