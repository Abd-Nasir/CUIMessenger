import 'package:cui_messenger/authentication/bloc/auth_bloc.dart';
import 'package:cui_messenger/authentication/bloc/auth_event.dart';
import 'package:cui_messenger/helpers/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestrictUser extends StatelessWidget {
  const RestrictUser({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var user = BlocProvider.of<AuthBloc>(context).state.user!;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * 0.15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_accounts,
              size: mediaQuery.size.height * 0.2,
              color: Palette.cuiPurple,
            ),
            SizedBox(
              height: mediaQuery.size.height * 0.02,
            ),
            const Text(
              "Account Restricted",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Palette.cuiPurple,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: mediaQuery.size.height * 0.08),
            Text(
              "Hey ${user.firstName} ${user.lastName}!,",
              style: const TextStyle(fontSize: 22),
            ),
            SizedBox(height: mediaQuery.size.height * 0.01),
            const Text(
              "Account has been restricted by the admin, Please contact to admin for further details.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Palette.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(height: mediaQuery.size.height * 0.06),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context)
                      .add(const AuthLogoutEvent());
                },
                child: const Text("Sign out"))
          ],
        ),
      ),
    );
  }
}
