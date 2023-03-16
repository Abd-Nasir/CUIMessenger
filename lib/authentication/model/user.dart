class UserData {
  late String uid;

  late String email;

  late String firstName;

  late String lastName;

  late String phoneNumber;

  late String dateOfBirth;

  late String profilePicture;

  late String role;
  late String regNo;

  UserData({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.profilePicture,
    required this.role,
    required this.regNo,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? json['_id'];
    email = json['email'];
    firstName = json['first-name'];
    lastName = json['last-name'];
    regNo = json['reg-no'];
    phoneNumber = json['phone'];
    dateOfBirth = json['date-of-birth'];
    profilePicture = json["imageUrl"];
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
    data["imageUrl"] = profilePicture;
    data["role"] = role;
    data['reg-no'] = regNo;
    return data;
  }
}
