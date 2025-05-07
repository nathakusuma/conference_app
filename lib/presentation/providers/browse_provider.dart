import 'package:flutter/material.dart';
import '../../domain/entities/conference.dart';
import '../../domain/usecases/conferences/get_conferences.dart';

class BrowseProvider with ChangeNotifier {
  final GetConferences _getConferences;
  BrowseProvider(this._getConferences);

  List<Conference> _conferences = [];
  ConferencePagination? _pagination;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  // Query/filter parameters:
  String? searchTitle;
  String? hostId;
  String status = 'approved';
  DateTime? startsAfter;
  DateTime? startsBefore;
  bool includePast = false;
  String orderBy = 'starts_at';
  String order = 'asc';

  static const int pageSize = 10;

  // For paginated calls:
  String? _lastId;

  List<Conference> get conferences => _conferences;
  bool get isLoading => _isLoading;
  bool get hasMore => _pagination?.hasMore ?? true;
  String? get errorMessage => _errorMessage;

  Future<void> refresh() async {
    _conferences = [];
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
      final (result, pagination) = await _getConferences(
        afterId: pageReset ? null : _lastId,
        limit: pageSize,
        hostId: hostId,
        status: status,
        startsAfter: startsAfter,
        startsBefore: startsBefore,
        includePast: includePast,
        orderBy: orderBy,
        order: order,
        title: searchTitle,
      );
      if (pageReset) {
        _conferences = result;
      } else {
        _conferences.addAll(result);
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

  void setFilters({
    String? title,
    String? hostId,
    DateTime? startsBefore,
    DateTime? startsAfter,
    bool? includePast,
    String? orderBy,
    String? order,
  }) {
    searchTitle = title ?? searchTitle;
    this.hostId = hostId ?? this.hostId;
    this.startsBefore = startsBefore ?? this.startsBefore;
    this.startsAfter = startsAfter ?? this.startsAfter;
    this.includePast = includePast ?? this.includePast;
    this.orderBy = orderBy ?? this.orderBy;
    this.order = order ?? this.order;
    refresh();
  }
}
