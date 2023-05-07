import 'package:flutter/material.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

class InitializeNotificationEvent extends NotificationEvent {
  const InitializeNotificationEvent() : super();
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

class LoadUserNotificationsEvent extends NotificationEvent {
  final String email;

  const LoadUserNotificationsEvent({required this.email}) : super();
}
