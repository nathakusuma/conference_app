import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/utils/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/domain/usecases/register_user.dart';
import 'features/auth/domain/usecases/request_register_otp.dart';
import 'features/auth/domain/usecases/request_reset_password_otp.dart';
import 'features/auth/domain/usecases/reset_password.dart';
import 'features/auth/domain/usecases/verify_register_otp.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_email_screen.dart';
import 'features/auth/presentation/screens/register_form_screen.dart';
import 'features/auth/presentation/screens/register_otp_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => TokenStorage(),
        ),
        Provider(
          create: (context) => ApiClient(
            baseUrl: 'https://conference.nathakusuma.com/api/v1',
            tokenStorage: context.read<TokenStorage>(),
          ),
        ),
        Provider(
          create: (context) => AuthRemoteDataSourceImpl(
            client: context.read<ApiClient>(),
          ),
        ),
        Provider(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSourceImpl>(),
            tokenStorage: context.read<TokenStorage>(),
          ),
        ),
        Provider(
          create: (context) => RequestRegisterOtp(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => VerifyRegisterOtp(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => RegisterUser(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => LoginUser(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => LogoutUser(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => RequestResetPasswordOtp(context.read<AuthRepositoryImpl>()),
        ),
        Provider(
          create: (context) => ResetPassword(context.read<AuthRepositoryImpl>()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            requestRegisterOtp: context.read<RequestRegisterOtp>(),
            verifyRegisterOtp: context.read<VerifyRegisterOtp>(),
            registerUser: context.read<RegisterUser>(),
            loginUser: context.read<LoginUser>(),
            logoutUser: context.read<LogoutUser>(),
            requestResetPasswordOtp: context.read<RequestResetPasswordOtp>(),
            resetPassword: context.read<ResetPassword>(),
          ),
        ),
      ],
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
        },
      ),
    );
  }
}

// Placeholder for home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Conference App!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (user != null)
              Text(
                'Logged in as: ${user.name ?? 'User'}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
