import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/network/api_client.dart';
import 'core/utils/token_storage.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/datasources/conference_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'data/repositories/conference_repository_impl.dart';
import 'data/datasources/registration_remote_data_source.dart';
import 'data/repositories/registration_repository_impl.dart';

import 'domain/repositories/conference_repository.dart';
import 'domain/repositories/registration_repository.dart';
import 'domain/usecases/auth/login_user.dart';
import 'domain/usecases/auth/logout_user.dart';
import 'domain/usecases/auth/register_user.dart';
import 'domain/usecases/auth/request_register_otp.dart';
import 'domain/usecases/auth/request_reset_password_otp.dart';
import 'domain/usecases/auth/reset_password.dart';
import 'domain/usecases/auth/verify_register_otp.dart';
import 'domain/usecases/profile/get_profile.dart';
import 'domain/usecases/profile/update_profile.dart';
import 'domain/usecases/conferences/get_conferences.dart';
import 'domain/usecases/conferences/get_conference_by_id.dart';
import 'domain/usecases/registrations/get_user_registrations.dart';
import 'domain/usecases/registrations/register_for_conference.dart';

import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/profile_provider.dart';
import 'presentation/providers/browse_provider.dart';
import 'presentation/providers/conference_detail_provider.dart';
import 'presentation/providers/registration_action_provider.dart';
import 'presentation/providers/registrations_provider.dart';

List<SingleChildWidget> buildProviders() {
  return [
    Provider<TokenStorage>(
      create: (_) => TokenStorage(),
    ),
    Provider<ApiClient>(
      create: (context) => ApiClient(
        baseUrl: 'https://conference.nathakusuma.com/api/v1',
        tokenStorage: context.read<TokenStorage>(),
      ),
    ),

    // DataSources
    Provider<AuthRemoteDataSource>(
      create: (context) => AuthRemoteDataSourceImpl(
        client: context.read<ApiClient>(),
      ),
    ),
    Provider<UserRemoteDataSource>(
      create: (context) => UserRemoteDataSourceImpl(
        client: context.read<ApiClient>(),
      ),
    ),
    // Repositories
    Provider<AuthRepositoryImpl>(
      create: (context) => AuthRepositoryImpl(
        remoteDataSource: context.read<AuthRemoteDataSource>(),
        tokenStorage: context.read<TokenStorage>(),
      ),
    ),
    Provider<UserRepositoryImpl>(
      create: (context) => UserRepositoryImpl(
        remoteDataSource: context.read<UserRemoteDataSource>(),
      ),
    ),
    Provider<RegistrationRemoteDataSource>(
      create: (context) => RegistrationRemoteDataSourceImpl(
        client: context.read<ApiClient>(),
      ),
    ),

    // Repositories
    Provider<RegistrationRepository>(
      create: (context) => RegistrationRepositoryImpl(
        remoteDataSource: context.read<RegistrationRemoteDataSource>(),
      ),
    ),

    // UseCases (Auth)
    Provider<RequestRegisterOtp>(
      create: (context) => RequestRegisterOtp(context.read<AuthRepositoryImpl>()),
    ),
    Provider<VerifyRegisterOtp>(
      create: (context) => VerifyRegisterOtp(context.read<AuthRepositoryImpl>()),
    ),
    Provider<RegisterUser>(
      create: (context) => RegisterUser(context.read<AuthRepositoryImpl>()),
    ),
    Provider<LoginUser>(
      create: (context) => LoginUser(context.read<AuthRepositoryImpl>()),
    ),
    Provider<LogoutUser>(
      create: (context) => LogoutUser(context.read<AuthRepositoryImpl>()),
    ),
    Provider<RequestResetPasswordOtp>(
      create: (context) => RequestResetPasswordOtp(context.read<AuthRepositoryImpl>()),
    ),
    Provider<ResetPassword>(
      create: (context) => ResetPassword(context.read<AuthRepositoryImpl>()),
    ),

    // UseCases (Profile)
    Provider<GetProfile>(
      create: (context) => GetProfile(context.read<UserRepositoryImpl>()),
    ),
    Provider<UpdateProfile>(
      create: (context) => UpdateProfile(context.read<UserRepositoryImpl>()),
    ),
    Provider<ConferenceRemoteDataSource>(
      create: (context) => ConferenceRemoteDataSourceImpl(
        client: context.read<ApiClient>(),
      ),
    ),
    Provider<ConferenceRepository>(
      create: (context) => ConferenceRepositoryImpl(
        remoteDataSource: context.read<ConferenceRemoteDataSource>(),
      ),
    ),
    Provider<GetConferences>(
      create: (context) => GetConferences(context.read<ConferenceRepository>()),
    ),
    Provider<GetConferenceById>(
      create: (context) => GetConferenceById(context.read<ConferenceRepository>()),
    ),

    // UseCases (Registration)
    Provider<GetUserRegistrations>(
      create: (context) => GetUserRegistrations(context.read<RegistrationRepository>()),
    ),
    Provider<RegisterForConference>(
      create: (context) => RegisterForConference(context.read<RegistrationRepository>()),
    ),

    // Providers
    ChangeNotifierProvider<AuthProvider>(
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
    ChangeNotifierProvider<UserProvider>(
      create: (context) => UserProvider(
        getProfile: context.read<GetProfile>(),
        updateProfile: context.read<UpdateProfile>(),
      ),
    ),
    ChangeNotifierProvider<BrowseProvider>(
      create: (context) => BrowseProvider(context.read<GetConferences>()),
    ),
    ChangeNotifierProvider<ConferenceDetailProvider>(
      create: (context) => ConferenceDetailProvider(context.read<GetConferenceById>()),
    ),
    ChangeNotifierProvider<RegistrationsProvider>(
      create: (context) => RegistrationsProvider(context.read<GetUserRegistrations>()),
    ),
    ChangeNotifierProvider<RegistrationActionProvider>(
      create: (context) => RegistrationActionProvider(context.read<RegisterForConference>()),
    ),
  ];
}
