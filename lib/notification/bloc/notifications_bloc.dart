import 'package:bloc/bloc.dart';
import 'package:cui_messenger/notification/bloc/notifications_event.dart';
import 'package:cui_messenger/notification/bloc/notifications_provider.dart';
import 'package:cui_messenger/notification/bloc/notifications_state.dart';
// import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(NotificationProvider notificationProvider)
      : super(ChatInitialState(notificationProvider: notificationProvider)) {
    on<InitializeNotificationEvent>((event, emit) async {
      emit(
          NotificationStateLoading(notificationProvider: notificationProvider));

      await notificationProvider.loadNotifications();
      await notificationProvider.loadNotices();
      emit(NotificationStateLoadSuccess(
          notificationProvider: notificationProvider));
    });
  }
}
