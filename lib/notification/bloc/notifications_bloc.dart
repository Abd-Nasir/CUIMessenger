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
      // await notificationProvider.connectSendBird(event.userId);
      // await notificationProvider.loadEmeNotifications(event.userId);
      emit(NotificationStateLoadSuccess(
          notificationProvider: notificationProvider));
    });

    // SendBird Part
    // on<StartNotificationChannelEvent>(
    //   (event, emit) async {
    //     GroupChannel channel =
    //         await notificationProvider.createChannel(event.users);

    //     // RouteGenerator.navigatorKey.currentState!
    //     //     .pushNamed(notificationsRoute, arguments: channel);
    //   },
    // );

    // on<LoadUserEmeMessageEvent>((event, emit) async {
    //   emit(NotificationStateMessageLoading(
    //       notificationProvider: notificationProvider));
    //   await notificationProvider.loadUserNotifications();

    //   emit(NotificationStateMessageLoaded(
    //       notificationProvider: notificationProvider));
    // });

    on<UpdateEmeStateEvent>(
      (event, emit) {
        emit(NotificationStateMessageSending(
            notificationProvider: notificationProvider));
        emit(NotificationStateLoadSuccess(
            notificationProvider: notificationProvider));
      },
    );

    // Send Notifications using SendBird
    // on<SendSMSEvent>(
    //   (event, emit) async {
    //     GroupChannel channel =
    //         await notificationProvider.createChannel(event.userIds);
    //     await notificationProvider.openChannel(channel);
    //     notificationProvider.sendMessage(
    //         message: event.message, context: event.context);
    //   },
    // );

    on<LoadUserNotificationsEvent>((event, emit) async {
      emit(
          NotificationStateLoading(notificationProvider: notificationProvider));
      await notificationProvider.getNotificatoinsList(event.email);
      emit(NotificationStateLoadSuccess(
          notificationProvider: notificationProvider));
    });
  }
}
