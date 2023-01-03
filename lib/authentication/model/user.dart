class User {
  late String uid;

  late String email;

  late String firstName;

  late String lastName;

  late String phoneNumber;

  late String dateOfBirth;

  late String profilePicture;

  late String imageKey;

  late String role;

  User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.profilePicture,
    required this.imageKey,
    required this.role,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? json['_id'];
    email = json['email'];
    firstName = json['first-name'];
    lastName = json['last-name'];
    phoneNumber = json['phone'];
    dateOfBirth = json['date-of-birth'];
    profilePicture = json["profile-picture"] ?? "";
    imageKey = json["profile-picture-key"];
    role = json["role"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['first-name'] = firstName;
    data['last-name'] = lastName;
    data['phone'] = phoneNumber;
    data['date-of-birth'] = dateOfBirth;
    data['profile-picture'] = profilePicture;
    data["profile-picture-key"] = imageKey;
    data["role"] = role;
    return data;
  }
}
