import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/request_register_otp.dart';
import '../../domain/usecases/request_reset_password_otp.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/verify_register_otp.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  loading,
  error,
}

class AuthProvider with ChangeNotifier {
  final RequestRegisterOtp _requestRegisterOtp;
  final VerifyRegisterOtp _verifyRegisterOtp;
  final RegisterUser _registerUser;
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;
  final RequestResetPasswordOtp _requestResetPasswordOtp;
  final ResetPassword _resetPassword;

  AuthStatus _status = AuthStatus.unauthenticated;
  User? _user;
  String? _errorMessage;
  Map<String, String> _fieldErrors = {};
  String? _otpEmail;
  String? _verifiedOtp;
  Timer? _resendTimer;
  int _resendSeconds = 0;

  AuthProvider({
    required RequestRegisterOtp requestRegisterOtp,
    required VerifyRegisterOtp verifyRegisterOtp,
    required RegisterUser registerUser,
    required LoginUser loginUser,
    required LogoutUser logoutUser,
    required RequestResetPasswordOtp requestResetPasswordOtp,
    required ResetPassword resetPassword,
  })  : _requestRegisterOtp = requestRegisterOtp,
        _verifyRegisterOtp = verifyRegisterOtp,
        _registerUser = registerUser,
        _loginUser = loginUser,
        _logoutUser = logoutUser,
        _requestResetPasswordOtp = requestResetPasswordOtp,
        _resetPassword = resetPassword;

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  Map<String, String> get fieldErrors => _fieldErrors;
  String? get otpEmail => _otpEmail;
  String? get verifiedOtp => _verifiedOtp;
  int get resendSeconds => _resendSeconds;
  bool get canResendOtp => _resendSeconds <= 0;

  void setOtpEmail(String email) {
    _otpEmail = email;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    _fieldErrors = {};
    notifyListeners();
  }

  String? getFieldError(String fieldName) {
    return _fieldErrors[fieldName];
  }

  void _handleApiException(dynamic e) {
    if (e is ApiException) {
      // Just display the message from the API for most errors
      _errorMessage = e.message;

      // Only process field errors for validation errors
      if (e.isValidationError) {
        _fieldErrors = e.extractValidationErrors();
      } else {
        _fieldErrors = {};
      }
    } else {
      _errorMessage = 'An unexpected error occurred. Please try again.';
      _fieldErrors = {};
    }
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        _resendSeconds--;
        notifyListeners();
      } else {
        _resendTimer?.cancel();
      }
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  // Registration flow
  Future<bool> requestRegistrationOtp(String email) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      await _requestRegisterOtp(email);

      _otpEmail = email;
      _startResendTimer();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyRegistrationOtp(String otp) async {
    if (_otpEmail == null) {
      _status = AuthStatus.error;
      _errorMessage = 'Email not provided. Please go back and try again.';
      notifyListeners();
      return false;
    }

    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      await _verifyRegisterOtp(_otpEmail!, otp);

      _verifiedOtp = otp;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;

      _handleApiException(e);

      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String password) async {
    if (_otpEmail == null || _verifiedOtp == null) {
      _status = AuthStatus.error;
      _errorMessage = 'Please complete OTP verification first.';
      notifyListeners();
      return false;
    }

    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      final result = await _registerUser(
        _otpEmail!,
        _verifiedOtp!,
        name,
        password,
      );

      _user = result.user;
      _status = AuthStatus.authenticated;

      // Clear registration data
      _otpEmail = null;
      _verifiedOtp = null;

      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
      return false;
    }
  }

  // Login flow
  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      final result = await _loginUser(email, password);

      _user = result.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _logoutUser();

      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
    }
  }

  // Password reset flow
  Future<bool> requestPasswordResetOtp(String email) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      await _requestResetPasswordOtp(email);

      _otpEmail = email;
      _startResendTimer();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String otp, String newPassword) async {
    if (_otpEmail == null) {
      _status = AuthStatus.error;
      _errorMessage = 'Email not provided. Please go back and try again.';
      notifyListeners();
      return false;
    }

    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      _fieldErrors = {};
      notifyListeners();

      final result = await _resetPassword(_otpEmail!, otp, newPassword);

      _user = result.user;
      _status = AuthStatus.authenticated;

      // Clear reset data
      _otpEmail = null;

      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _handleApiException(e);
      notifyListeners();
      return false;
    }
  }
}
