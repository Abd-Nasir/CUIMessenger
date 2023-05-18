import 'package:flutter/material.dart';

@immutable
abstract class NotificationEvent {
  const NotificationEvent();
}

class InitializeNotificationEvent extends NotificationEvent {
  const InitializeNotificationEvent() : super();
}
