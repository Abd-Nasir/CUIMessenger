import 'package:cui_messenger/groupchat/constants/message_enum.dart';


class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply(this.message, this.isMe, this.messageEnum);
}
