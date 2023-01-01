import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/helpers/routes/routegenerator.dart';
import 'package:cui_messenger/helpers/routes/routenames.dart';
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Palette.white,
      body: Padding(
        padding: EdgeInsets.only(top: mediaQuery.size.height * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 160,
              width: 160,
              alignment: Alignment.topCenter,
            ),
            const Text(
              "CUI Messenger",
              style: TextStyle(
                  color: Palette.cuiBlue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Welcome',
              style: TextStyle(
                  color: Palette.cuiBlue,
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Select who you are?',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 30),
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
                      color: isTeacher ? Palette.frenchBlue : Palette.white,
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
                            'Teacher',
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
                      color: isStudent ? Palette.frenchBlue : Colors.white,
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
                ))
          ],
        ),
      ),
    );
  }
}
