import 'package:cached_network_image/cached_network_image.dart';

import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
import 'package:cui_messenger/settings/bloc/settings_bloc.dart';
import 'package:cui_messenger/settings/bloc/settings_event.dart';
import 'package:cui_messenger/settings/bloc/settings_state.dart';
import 'package:cui_messenger/settings/model/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '/authentication/bloc/auth_bloc.dart';
import '/authentication/bloc/auth_event.dart';
import '/helpers/routes/routegenerator.dart';

import '/helpers/style/colors.dart';
// import 'package:safepall/screens/maps/bloc/map_bloc.dart';
// import 'package:safepall/screens/settings/bloc/settings_bloc.dart';
// import 'package:safepall/screens/settings/bloc/settings_event.dart';
// import 'package:safepall/screens/settings/bloc/settings_state.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:vibration/vibration.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool emergencyAlarm = false;
  UserModel? currentUser;
  // late String imageUrl = "http://cdn.onlinewebfonts.com/svg/img_401900.png";

  @override
  void initState() {
    currentUser = BlocProvider.of<AuthBloc>(context).state.user;

    // AuthProvider().imageUrl().then((value) {
    //   print(value);
    //   imageUrl = value!;
    // });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return SafeArea(
      bottom: false,
      child: Container(
        color: Palette.white,
        padding: EdgeInsets.only(
          top: mediaQuery.size.width * 0.04,
          left: mediaQuery.size.width * 0.04,
          right: mediaQuery.size.width * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Palette.textColor,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            const Text(
              "Account",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Palette.textColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            createAccountRow(mediaQuery),
            SizedBox(height: mediaQuery.size.height * 0.04),
            const Text(
              "Settings",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Palette.textColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: mediaQuery.size.height * 0.02),
            BlocConsumer<SettingsBloc, SettingsState>(
                listener: (context, state) {
              if (state is SettingStateNotificationUpdated) {
                print("notification updated");
                setState(() {});
              }
              if (state is SettingStateLoading) {
                print("state loading");
                setState(() {});
              }
            }, builder: (context, state) {
              if (state is SettingStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SettingStateNotificationUpdated) {
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // createInformationTile(
                        //   mediaQuery: mediaQuery,
                        //   color: Palette.privacyPolicy,
                        //   tileText: AppLocalizations.of(context)
                        //       .translate('payment_details'),
                        //   icon: Icons.payment,
                        //   onTap: () {
                        //     RouteGenerator.navigatorKey.currentState!
                        //         .pushNamed(paymentDetailsRoute);
                        //   },
                        // ),
                        createSettingTile(
                          mediaQuery: mediaQuery,
                          color: Palette.cuiPurple,
                          tileText: "Chat Notification",
                          icon: Icons.chat_sharp,
                          // switchValue: false,
                          switchValue: state
                              .settingsProvider.settings!.chatNotifications,
                          // state.settings.chatNotifications,
                          switchOnChaged: (value) {
                            BlocProvider.of<SettingsBloc>(context)
                                .add(ChangeNoticeNotificationsEvent(
                              setting: Setting(
                                  chatNotifications: value,
                                  noticeNotification: state.settingsProvider
                                      .settings!.noticeNotification),
                            ));
                            setState(() {
                              state.settingsProvider.settings!
                                  .chatNotifications = value;
                            });
                          },
                        ),
                        createSettingTile(
                          mediaQuery: mediaQuery,
                          color: Palette.faceid,
                          tileText: "Disable Notifices Notifications",
                          icon: Icons.notifications_off,
                          switchValue: state
                              .settingsProvider.settings!.noticeNotification,
                          switchOnChaged: (value) {
                            // print(value);
                            BlocProvider.of<SettingsBloc>(context).add(
                                ChangeNoticeNotificationsEvent(
                                    setting: Setting(
                                        chatNotifications: state
                                            .settingsProvider
                                            .settings!
                                            .noticeNotification,
                                        noticeNotification: value)));
                            setState(() {
                              state.settingsProvider.settings!
                                  .noticeNotification = value;
                            });
                          },
                        ),
                        createInformationTile(
                          mediaQuery: mediaQuery,
                          color: Palette.help,
                          tileText: "Change Password",
                          icon: Icons.key_sharp,
                          onTap: () {
                            RouteGenerator.navigatorKey.currentState!
                                .pushNamed(changePasswordRoute);
                          },
                        ),
                        createInformationTile(
                          mediaQuery: mediaQuery,
                          color: Palette.blueInformation,
                          tileText: "About App",
                          icon: Icons.info_sharp,
                          onTap: () {
                            RouteGenerator.navigatorKey.currentState!
                                .pushNamed(aboutAppRoute);
                          },
                        ),
                        createInformationTile(
                          mediaQuery: mediaQuery,
                          color: Palette.logOut,
                          tileText: "Log Out",
                          icon: Icons.logout_sharp,
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Palette.white,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: mediaQuery.size.width * 0.06,
                                  vertical: mediaQuery.size.height * 0.02),
                              title: const Text(
                                "Log Out",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Palette.textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              content: const Text(
                                "Are you sure you want to log Out?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Palette.textColor,
                                  fontSize: 14.0,
                                ),
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        RouteGenerator
                                            .navigatorKey.currentState!
                                            .pop('dialog');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 12.0),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Palette.textColor,
                                              fontSize: 12.0),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        RouteGenerator
                                            .navigatorKey.currentState!
                                            .pop('dialog');
                                        // RouteGenerator.navigatorKey.currentState!
                                        //     .pushNamedAndRemoveUntil(
                                        //         logInRoute, (route) => false);
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(const AuthLogoutEvent());
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          decoration: BoxDecoration(
                                            color: Palette.red,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            boxShadow: [
                                              BoxShadow(
                                                offset: const Offset(0.0, 0.0),
                                                blurRadius: 16.0,
                                                color: Palette.red
                                                    .withOpacity(0.25),
                                              ),
                                            ],
                                          ),
                                          child: const Text(
                                            "Log Out",
                                            style: TextStyle(
                                                color: Palette.white,
                                                fontSize: 12.0),
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget createNotificationTile(
      {required MediaQueryData mediaQuery,
      required Color color,
      required String tileText,
      required IconData icon,
      required bool switchValue,
      required void Function() switchOnChaged}) {
    return GestureDetector(
      onTap: switchOnChaged,
      child: Container(
        margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.01),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: color.withOpacity(0.25),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.04),
            Expanded(
              child: Text(
                tileText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              switchValue ? "On" : "Off",
              style: TextStyle(
                color: switchValue ? Palette.green : Palette.red,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.02),
          ],
        ),
      ),
    );
  }

  Widget createSettingTile(
      {required MediaQueryData mediaQuery,
      required Color color,
      required String tileText,
      required IconData icon,
      required bool switchValue,
      required void Function(bool) switchOnChaged}) {
    return Container(
      margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.01),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: mediaQuery.size.height * 0.01,
                horizontal: mediaQuery.size.width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200.0),
              color: color.withOpacity(0.25),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.04),
          Expanded(
            child: Text(
              tileText,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Palette.textColor,
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: switchValue,
            onChanged: switchOnChaged,
            activeColor: Palette.frenchBlue,
            inactiveTrackColor: Palette.grey,
          ),
          SizedBox(width: mediaQuery.size.width * 0.02),
        ],
      ),
    );
  }

  Widget createInformationTile({
    required MediaQueryData mediaQuery,
    required Color color,
    required String tileText,
    required IconData icon,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: mediaQuery.size.height * 0.02),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200.0),
                color: color.withOpacity(0.25),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.04),
            Expanded(
              child: Text(
                tileText,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Palette.textColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.size.height * 0.01,
                  horizontal: mediaQuery.size.width * 0.02),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Palette.buttonBackground,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Palette.frenchBlue,
                size: mediaQuery.size.height * 0.02,
              ),
            ),
            SizedBox(width: mediaQuery.size.width * 0.02),
          ],
        ),
      ),
    );
  }

  Widget createAccountRow(MediaQueryData mediaQuery) {
    return GestureDetector(
      onTap: () {
        RouteGenerator.navigatorKey.currentState!.pushNamed(editProfileRoute);
        // BlocProvider.of<NavBarBloc>(context)
        //     .add(NavBarShowEditProfileEvent(4, editProfileRoute));
      },
      child: Row(
        children: [
          Container(
            height: mediaQuery.size.width * 0.18,
            width: mediaQuery.size.width * 0.18,
            decoration: BoxDecoration(
                color: Palette.white,
                borderRadius: BorderRadius.circular(200.0),
                boxShadow: [
                  BoxShadow(
                      color: Palette.frenchBlue.withOpacity(0.25),
                      offset: const Offset(0.0, 4.0),
                      blurRadius: 16.0)
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.0),
              child: CachedNetworkImage(
                imageUrl: BlocProvider.of<AuthBloc>(context)
                    .state
                    .user!
                    .profilePicture,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.06),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${BlocProvider.of<AuthBloc>(context).state.user!.firstName} ${BlocProvider.of<AuthBloc>(context).state.user!.lastName}',
                  style: const TextStyle(
                    color: Palette.textColor,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: mediaQuery.size.height * 0.01),
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    color: Palette.grey,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: mediaQuery.size.height * 0.01,
                horizontal: mediaQuery.size.width * 0.02),
            decoration: BoxDecoration(
              color: Palette.buttonBackground,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Palette.frenchBlue,
            ),
          ),
          SizedBox(width: mediaQuery.size.width * 0.04),
        ],
      ),
    );
  }
}
