import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectUserScreen extends StatefulWidget {
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool isTeacher = false;
  bool isStudent = false;
  final List<Map> notices = [];
  bool isLoading = true;

  void loadNotices() async {
    await FirebaseFirestore.instance
        .collection("public-noticeboard")
        .get()
        .then((value) {
      value.docs.forEach((notice) {
        notices.add(notice.data());
      });
      print(notices);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 0), () {
    loadNotices();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Palette.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30),
            const Text(
              'Welcome to',
              style: TextStyle(
                  color: Palette.cuiPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            const Text(
              "CUI Messenger",
              style: TextStyle(
                  color: Palette.cuiBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: mediaQuery.size.height * 0.45,
              margin: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Palette.cuiPurple.withOpacity(0.35),
                    spreadRadius: 2,
                    blurRadius: 7)
              ], borderRadius: BorderRadius.circular(10), color: Palette.white),
              child: Container(
                  margin: const EdgeInsets.all(7),
                  width: double.infinity,
                  // height: mediaQuery.size.height * 0.4,
                  // padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/noticeboard.jpg"),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "NOTICEBOARD",
                        style: TextStyle(
                            color: Palette.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        color: Palette.white,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 0.03),
                        height: mediaQuery.size.height * 0.33,
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Palette.yellow,
                                ),
                              )
                            : ListView.builder(
                                itemCount: notices.length,
                                itemBuilder: ((context, index) {
                                  return Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notices[index]["title"],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Palette.yellow,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        " ${notices[index]["text"]}",
                                        style: const TextStyle(
                                            color: Palette.white),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }),
                              ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Select who you are?',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 150,
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isTeacher = !isTeacher;
                              isStudent = false;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            color: isTeacher ? Palette.aeroBlue : Palette.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Palette.cuiBlue,
                                    child: Icon(
                                      Icons.people,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Faculty',
                                  style: TextStyle(
                                      color: isTeacher
                                          ? Palette.white
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 150,
                        padding: const EdgeInsets.all(15.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isStudent = !isStudent;
                              isTeacher = false;
                            });
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                            color: isStudent ? Palette.aeroBlue : Colors.white,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Palette.cuiPurple,
                                    child: Icon(
                                      Icons.school,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Student',
                                  style: TextStyle(
                                      color: isStudent
                                          ? Palette.white
                                          : Colors.grey.shade600,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  TextButton(
                    onPressed: (() {
                      if (isStudent == true) {
                        setState(() {});
                        BlocProvider.of<AuthBloc>(context)
                            .add(const AuthSelectStudentEvent());
                      } else if (isTeacher == true) {
                        setState(() {});
                        BlocProvider.of<AuthBloc>(context)
                            .add(const AuthSelectTeacherEvent());
                        // RouteGenerator.navigatorKey.currentState!
                        //     .pushNamed(teacherLoginScreenRoute);
                      }
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 18,
                              color: Palette.cuiBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Palette.cuiBlue,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
