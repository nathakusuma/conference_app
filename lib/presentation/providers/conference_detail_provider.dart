import 'package:flutter/foundation.dart';
import '../../domain/entities/conference.dart';
import '../../domain/usecases/conferences/get_conference_by_id.dart';

class ConferenceDetailProvider with ChangeNotifier {
  final GetConferenceById _getDetail;

  Conference? _conference;
  bool _loading = false;
  String? _errorMessage;

  Conference? get conference => _conference;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  ConferenceDetailProvider(this._getDetail);

  Future<void> fetch(String id) async {
    _loading = true;
    _errorMessage = null;
    _conference = null;
    notifyListeners();
    try {
      _conference = await _getDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  void clear() {
    _conference = null;
    _errorMessage = null;
    _loading = false;
    notifyListeners();
  }
}
