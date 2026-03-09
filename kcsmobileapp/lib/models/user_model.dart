class AppUser {
  final String uid;
  final String email;
  final String? displayName;

  AppUser({required this.uid, required this.email, this.displayName});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'email': email, 'displayName': displayName};
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
    );
  }
}
