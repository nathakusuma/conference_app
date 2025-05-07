import 'package:conference_app/presentation/screens/conferences/browse_screen.dart';
import 'package:conference_app/presentation/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di_container.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_email_screen.dart';
import 'presentation/screens/auth/register_otp_screen.dart';
import 'presentation/screens/auth/register_form_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/auth/reset_password_screen.dart';
import 'presentation/screens/navigation/main_navigation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: buildProviders(),
      child: MaterialApp(
        title: 'Conference App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          MainNavigationScreen.routeName: (context) => const MainNavigationScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterEmailScreen.routeName: (context) => const RegisterEmailScreen(),
          RegisterOtpScreen.routeName: (context) => const RegisterOtpScreen(),
          RegisterFormScreen.routeName: (context) => const RegisterFormScreen(),
          ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
          ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          BrowseScreen.routeName: (context) => const BrowseScreen(),
        },
      ),
    );
  }
}
