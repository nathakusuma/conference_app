import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di_container.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_email_screen.dart';
import 'presentation/screens/auth/register_otp_screen.dart';
import 'presentation/screens/auth/register_form_screen.dart';
import 'presentation/screens/auth/forgot_password_screen.dart';
import 'presentation/screens/auth/reset_password_screen.dart';
import 'presentation/screens/users/profile_screen.dart';
import 'presentation/providers/auth_provider.dart';

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
          '/': (context) => const HomeScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          RegisterEmailScreen.routeName: (context) => const RegisterEmailScreen(),
          RegisterOtpScreen.routeName: (context) => const RegisterOtpScreen(),
          RegisterFormScreen.routeName: (context) => const RegisterFormScreen(),
          ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
          ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed(ProfileScreen.routeName);
        },
        child: const Text('View/Edit Profile'),
      ),
    );
  }
}
