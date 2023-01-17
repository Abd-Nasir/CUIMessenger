import 'dart:async';
import 'package:cui_messenger/chat/view/chat_home_screen.dart';
import 'package:cui_messenger/feed/view/feed_screen.dart';
import 'package:cui_messenger/settings/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:cui_messenger/authentication/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
// import '/authentication/model/user.dart';
// import 'package:safepall/screens/chat/view/chat_home_screen.dart';
// import 'package:safepall/screens/contacts/bloc/contact_bloc.dart';
// import 'package:safepall/screens/contacts/bloc/contact_event.dart';
// import 'package:safepall/screens/contacts/bloc/contact_state.dart';
// import 'package:safepall/screens/contacts/model/add_location_model.dart';
// import 'package:safepall/screens/contacts/model/contact.dart';
// import 'package:safepall/screens/contacts/view/contacts_list.dart';
// import 'package:safepall/screens/feeds/view/feed_screen.dart';
import '/helpers/style/colors.dart';
import '/home/homepage.dart';
// import 'package:safepall/screens/lang/app_localization.dart';
// import 'package:safepall/screens/maps/bloc/map_bloc.dart';
// import 'package:safepall/screens/maps/bloc/map_event.dart';
// import 'package:safepall/screens/maps/view/maps_screen.dart';
// import 'package:safepall/screens/notifications/bloc/notifications_bloc.dart';
// import 'package:safepall/screens/notifications/bloc/notifications_event.dart';
// import '../settings/view/settings.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int selectedIndex = 0;
  // late User user;

  @override
  void initState() {
    // user = BlocProvider.of<AuthBloc>(context).state.user as User;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.aliceBlue,
      bottomNavigationBar: FlashyTabBar(
        height: (mediaQuery.size.height * 0.1 > 100)
            ? 100
            : mediaQuery.size.height * 0.1,
        selectedIndex: selectedIndex,
        animationDuration: const Duration(milliseconds: 400),
        animationCurve: Curves.linear,
        items: [
          // FlashyTabBarItem(
          //   icon: const Icon(Icons.home),
          //   title: Text(
          //     AppLocalizations.of(context).translate('home'),
          //     style: const TextStyle(fontSize: 10.0),
          //   ),
          //   activeColor: Palette.frenchBlue,
          //   inactiveColor: Palette.hintGrey,
          // ),
          FlashyTabBarItem(
            icon: const Icon(Icons.notifications_active_rounded),
            title: const Text(
              "Notices",
              style: TextStyle(fontSize: 10.0),
            ),
            activeColor: Palette.cuiPurple,
            inactiveColor: Palette.hintGrey,
          ),

          FlashyTabBarItem(
            icon: const Icon(Icons.chat_rounded),
            title: const Text(
              "Chat",
              style: TextStyle(fontSize: 10.0),
            ),
            activeColor: Palette.cuiPurple,
            inactiveColor: Palette.hintGrey,
          ),

          FlashyTabBarItem(
            icon: const Icon(Icons.rss_feed),
            title: const Text(
              "Feed",
              style: TextStyle(fontSize: 10.0),
            ),
            activeColor: Palette.cuiPurple,
            inactiveColor: Palette.hintGrey,
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.settings),
            title: const Text(
              "Settings",
              style: TextStyle(fontSize: 10.0),
            ),
            activeColor: Palette.cuiPurple,
            inactiveColor: Palette.hintGrey,
          ),
        ],
        onItemSelected: (index) => setState(
          () {
            selectedIndex = index;
          },
        ),
      ),
      body: buildBody(),
    );

    // return GNav(
    //   backgroundColor: Palette.frenchBlue,
    //   haptic: true,
    //   selectedIndex: selectedIndex,
    //   tabBorderRadius: 8.0,
    //   color: Palette.aliceBlue,
    //   gap: 0.0,
    //   activeColor: Palette.frenchBlue,
    //   tabBackgroundColor: Palette.aliceBlue,
    //   tabMargin: EdgeInsets.only(
    //       top: 12.0,
    //       left: 10.0,
    //       right: 10.0,
    //       bottom: mediaQuery.size.height * 0.028),
    //   padding: EdgeInsets.symmetric(
    //       vertical: mediaQuery.size.height * 0.006,
    //       horizontal: mediaQuery.size.width * 0.01),
    //   textStyle: const TextStyle(
    //       fontSize: 10.0,
    //       fontWeight: FontWeight.bold,
    //       color: Palette.frenchBlue),
    //   tabs: [
    //     GButton(
    //       icon: Icons.home,
    //       text: AppLocalizations.of(context).translate('home'),
    //     ),
    //     GButton(
    //       icon: Icons.contacts,
    //       text: AppLocalizations.of(context).translate('contacts'),
    //     ),
    //     GButton(
    //       icon: Icons.map_rounded,
    //       text: AppLocalizations.of(context).translate('danger_zones'),
    //     ),
    //     const GButton(
    //       icon: Icons.rss_feed,
    //       text: 'Feed',
    //     ),
    //     GButton(
    //       icon: Icons.settings,
    //       text: AppLocalizations.of(context).translate('settings'),
    //     ),
    //   ],
    //   onTabChange: (value) {
    //     if (value == 0) {
    //       BlocProvider.of<NavBarBloc>(context)
    //           .add(NavBarShowHomePageEvent(0));
    //     } else if (value == 1) {
    //       BlocProvider.of<NavBarBloc>(context)
    //           .add(NavBarShowContactPageEvent(1));
    //     } else if (value == 2) {
    //       BlocProvider.of<NavBarBloc>(context)
    //           .add(NavBarShowMapsHomePageEvent(2));
    //     } else if (value == 3) {
    //       BlocProvider.of<NavBarBloc>(context)
    //           .add(NavBarShowFeedPageEvent(3));
    //     } else if (value == 4) {
    //       BlocProvider.of<NavBarBloc>(context)
    //           .add(NavBarShowSettingsPageEvent(4));
    //     }
    //   },
    // );
  }

  buildBody() {
    if (selectedIndex == 0) {
      // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // print("\n\nCustomer info: ${customerInfo.toJson()}");
      return const HomePage();
    } else if (selectedIndex == 1) {
      return const ChatHomeScreen();
    } else if (selectedIndex == 2) {
      return const FeedScreen();
    } else if (selectedIndex == 3) {
      return const SettingsPage();
    }
  }
}
