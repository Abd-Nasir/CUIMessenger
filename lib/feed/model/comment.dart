class Comment {
  late String uid;
  late String commentId;
  late String regNo;
  late String name;
  late String text;
  late String userImage;
  late String commentImage;
  late String createdAt;

  Comment({
    required this.uid,
    required this.commentId,
    required this.regNo,
    required this.name,
    required this.text,
    required this.userImage,
    required this.commentImage,
    required this.createdAt,
  });

  Comment.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    regNo = json['reg-no'];
    commentId = json['comment-id'];
    commentImage = json['comment-image'];
    text = json['text'];
    name = json['full-name'];
    userImage = json['user-image'];
    // message = json['message'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    late Map<String, dynamic> data = <String, dynamic>{};
    data['comment-id'] = commentId;
    data['uid'] = uid;
    data['reg-no'] = regNo;
    data['user-image'] = userImage;
    data['comment-image'] = commentImage;
    data['text'] = text;
    data['full-name'] = name;
    data['createdAt'] = createdAt;

    return data;
  }
}
