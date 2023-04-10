import 'package:flutter/foundation.dart' show immutable;

import 'notifications_provider.dart';

@immutable
abstract class NotificationState {
  final NotificationProvider notificationProvider;
  const NotificationState({required this.notificationProvider});
}

class ChatInitialState extends NotificationState {
  const ChatInitialState({required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}

class NotificationStateLoading extends NotificationState {
  const NotificationStateLoading(
      {required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}

class NotificationStateLoadSuccess extends NotificationState {
  const NotificationStateLoadSuccess(
      {required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}

class NotificationStateMessageLoading extends NotificationState {
  const NotificationStateMessageLoading(
      {required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}

class NotificationStateMessageLoaded extends NotificationState {
  const NotificationStateMessageLoaded(
      {required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}

class NotificationStateMessageSending extends NotificationState {
  const NotificationStateMessageSending(
      {required NotificationProvider notificationProvider})
      : super(notificationProvider: notificationProvider);
}
