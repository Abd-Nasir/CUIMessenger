import 'package:cui_messenger/chat/constants/constant_utils.dart';
import 'package:cui_messenger/chat/methods/chat_methods.dart';
import 'package:cui_messenger/authentication/model/user_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ContactsScreen extends StatefulWidget {
  final bool isChat;
  String? value;
  ContactsScreen({required this.isChat, this.value, super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: FutureBuilder<List<UserModel>>(
          future: ChatMethods().getContacts1(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // if (snapshot.data == null) {
            //   // return const Center(
            //   //   child: Text("Nothing to show you"),
            //   // );
            //   return getNewContactPrompt(context);
            // }
            // if (snapshot.data!.isEmpty) {
            //   // return const Center(
            //   //   child: Text("Nothing to show you"),
            //   // );
            //   return getNewContactPrompt(context);
            // }
            List<UserModel> temp = [];
            if (widget.value != null) {
              for (var element in snapshot.data!) {
                if (element.firstName.contains(widget.value!)) {
                  temp.add(element);
                }
              }
            } else {
              temp = snapshot.data!;
            }
            if (temp.isEmpty) {
              return Center(
                child: returnNothingToShow(),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  var data = snapshot.data![index];
                  return getContactCard(data, context, widget.isChat);
                }));
          }),
    );
  }
}
