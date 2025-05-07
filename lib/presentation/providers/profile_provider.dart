import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/profile/get_profile.dart';
import '../../domain/usecases/profile/update_profile.dart';

enum UserStatus {
  initial,
  loading,
  loaded,
  error,
}

class UserProvider with ChangeNotifier {
  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;

  User? _user;
  UserStatus _status = UserStatus.initial;
  String? _errorMessage;

  User? get user => _user;
  UserStatus get status => _status;
  String? get errorMessage => _errorMessage;

  UserProvider({required GetProfile getProfile, required UpdateProfile updateProfile})
      : _getProfile = getProfile,
        _updateProfile = updateProfile;

  Future<void> fetchProfile() async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      _user = await _getProfile();
      _status = UserStatus.loaded;
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<bool> updateProfile({required String name, String? bio}) async {
    _status = UserStatus.loading;
    notifyListeners();
    try {
      _user = await _updateProfile(name: name, bio: bio);
      _status = UserStatus.loaded;
      notifyListeners();
      return true;
    } catch (e) {
      _status = UserStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
