import 'package:cui_messenger/feed/view/feed_screen.dart';
import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/constants/constants.dart';
import 'package:cui_messenger/chat/screens/group/screens/create_group_screen.dart';
import 'package:cui_messenger/chat/screens/toppages/chat/chat_list_screen.dart';
import 'package:cui_messenger/notification/view/notifications.dart';
import 'package:cui_messenger/settings/view/settings.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/helpers/style/colors.dart';

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
    if (userInfo == null) {
      fetchUserInfo();
    }
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton:
          selectedIndex == 1 ? _getFloatingButton() : const SizedBox(),
      resizeToAvoidBottomInset: false,
      backgroundColor: Palette.white,
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
  }

  buildBody() {
    if (selectedIndex == 0) {
      // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      // print("\n\nCustomer info: ${customerInfo.toJson()}");
      return const NotificationsPage();
    } else if (selectedIndex == 1) {
      return ChatContactsListScreen(value: '');
    } else if (selectedIndex == 2) {
      return const FeedScreen();
    } else if (selectedIndex == 3) {
      return const SettingsPage();
    }
  }

  _getFloatingButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        menuItemStyleData: MenuItemStyleData(height: 30),
        isExpanded: true,
        customButton: Card(
          elevation: 8,
          color: Palette.cuiPurple,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: const Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        items: [
          ...MenuItemsHome.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItemsHome.buildItem(item),
            ),
          ),
          // const DropdownMenuItem<Divider>(
          //     enabled: false, child: Divider()),
        ],
        onChanged: (value) {
          MenuItemsHome.onChanged(context, value as MenuItem, showNewMessage);
        },
        dropdownStyleData: DropdownStyleData(
          width: 150,
          padding: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Palette.cuiPurple,
          ),
          elevation: 8,
          offset: const Offset(0, 8),
        ),
      ),
    );
  }
}

class MenuItemsHome {
  static List<MenuItem> firstItems = [newChat, newGroup];
  // static List<MenuItem> secondItems = [logout];

  static var newChat = const MenuItem(
    text: "New Chat",
    icon: FontAwesomeIcons.commentDots,
  );

  // static var newContact =
  //     const MenuItem(text: 'New Contact', icon: Icons.people);

  static var newGroup =
      const MenuItem(text: "New Group", icon: Icons.groups_rounded);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 15),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(
    BuildContext context,
    MenuItem item,
    Function newChatCallBack,
  ) {
    if (item == MenuItemsHome.newChat) {
      newChatCallBack(context);
    } else if (item == MenuItemsHome.newGroup) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateGroupScreen()));
    }
  }
}
