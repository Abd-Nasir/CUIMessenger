import 'package:flutter/material.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

class InitializeNotificationEvent extends NotificationEvent {
  final String userId;
  const InitializeNotificationEvent({required this.userId}) : super();
}

class CreateChatChannelEvent extends NotificationEvent {
  const CreateChatChannelEvent() : super();
}

class StartNotificationChannelEvent extends NotificationEvent {
  final List<String> users;
  const StartNotificationChannelEvent({required this.users}) : super();
}

class LoadUserEmeMessageEvent extends NotificationEvent {
  const LoadUserEmeMessageEvent() : super();
}

class UpdateEmeStateEvent extends NotificationEvent {
  const UpdateEmeStateEvent() : super();
}

class SendSMSEvent extends NotificationEvent {
  final String message;
  final List<String> userIds;
  final BuildContext context;
  const SendSMSEvent(
      {required this.message, required this.userIds, required this.context})
      : super();
}

class LoadUserNotificationsEvent extends NotificationEvent {
  final String email;

  const LoadUserNotificationsEvent({required this.email}) : super();
}
