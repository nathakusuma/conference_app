import 'package:flutter/material.dart';
import '../../domain/entities/conference.dart';
import '../../domain/usecases/registrations/get_user_registrations.dart';

class RegistrationsProvider with ChangeNotifier {
  final GetUserRegistrations _getUserRegistrations;

  RegistrationsProvider(this._getUserRegistrations);

  List<Conference> _registrations = [];
  ConferencePagination? _pagination;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  bool _includePast = false;

  static const int pageSize = 10;

  // For paginated calls:
  String? _lastId;

  List<Conference> get registrations => _registrations;
  bool get isLoading => _isLoading;
  bool get hasMore => _pagination?.hasMore ?? true;
  String? get errorMessage => _errorMessage;
  bool get includePast => _includePast;

  Future<void> refresh() async {
    _registrations = [];
    _lastId = null;
    await fetch(pageReset: true);
  }

  Future<void> fetch({bool pageReset = false}) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    _hasError = false;
    notifyListeners();

    try {
      final (result, pagination) = await _getUserRegistrations(
        afterId: pageReset ? null : _lastId,
        limit: pageSize,
        includePast: _includePast,
      );

      if (pageReset) {
        _registrations = result;
      } else {
        _registrations.addAll(result);
      }

      _pagination = pagination;
      _lastId = pagination.lastId;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setIncludePast(bool value) {
    _includePast = value;
    refresh();
  }
}
