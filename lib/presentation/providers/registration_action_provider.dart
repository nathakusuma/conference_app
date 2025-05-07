import 'package:flutter/material.dart';
import '../../domain/usecases/registrations/register_for_conference.dart';

enum RegistrationStatus {
  initial,
  loading,
  success,
  error,
}

class RegistrationActionProvider with ChangeNotifier {
  final RegisterForConference _registerForConference;

  RegistrationActionProvider(this._registerForConference);

  RegistrationStatus _status = RegistrationStatus.initial;
  String? _errorMessage;

  RegistrationStatus get status => _status;
  String? get errorMessage => _errorMessage;

  Future<bool> registerForConference(String conferenceId) async {
    _status = RegistrationStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _registerForConference(conferenceId);
      _status = RegistrationStatus.success;
      notifyListeners();
      return true;
    } catch (e) {
      _status = RegistrationStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _status = RegistrationStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
