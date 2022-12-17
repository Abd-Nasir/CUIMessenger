import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return MaterialApp(
        title: 'CUI Messenger',
        home: Scaffold(
          backgroundColor: Palette.cuiOffWhite,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 160,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 160,
                width: 160,
                alignment: Alignment.topCenter,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "CUI Messenger",
                style: TextStyle(
                    color: Palette.cuiBlue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 70,
              ),
              const Text(
                'Welcome',
                style: TextStyle(
                    color: Palette.cuiBlue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  'Select who you are?',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 150,
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
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
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 150,
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
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
                                color: Colors.grey.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 20, left: 140.0, right: 139.0),
                child: TextButton(
                    onPressed: (() {}),
                    child: Row(
                      children: const [
                        Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 18,
                              color: Palette.cuiBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward,
                          color: Palette.cuiBlue,
                        )
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
