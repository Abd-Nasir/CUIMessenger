class Chat {
  late Sender sender;
  late Sender recepient;
  late String message;
  late DateTime sentTime;
  late DateTime? readTime;
  late String? file;
  late String? fileType;
  late String sId;

  Chat({
    required this.sender,
    required this.recepient,
    required this.message,
    required this.sentTime,
    required this.readTime,
    required this.file,
    required this.fileType,
    required this.sId,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    sender = Sender.fromJson(json['sender']);
    recepient = Sender.fromJson(json['recepient']);
    message = json['message'];
    sentTime = DateTime.parse(json['sent_time']);
    readTime = json['read_time'];
    file = json['file'];
    fileType = json['file_type'];
    sId = json['_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['sender'] = sender.toJson();

    data['recepient'] = recepient.toJson();

    data['message'] = message;
    data['sent_time'] = sentTime.toString();
    if (readTime != null) {
      data['read_time'] = readTime.toString();
    } else {
      data['read_time'] = null;
    }
    data['file'] = file;
    data['file_type'] = fileType;
    data['_id'] = sId;
    return data;
  }
}

class Sender {
  late String uid;
  late String name;
  late String phone;
  late String email;

  Sender(
      {required this.uid,
      required this.name,
      required this.phone,
      required this.email});

  Sender.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    return data;
  }
}
