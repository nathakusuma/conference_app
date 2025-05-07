import '../../core/network/api_client.dart';
import '../../domain/entities/conference.dart';
import '../models/conference_model.dart';

class ConferencePaginationModel extends ConferencePagination {
  ConferencePaginationModel({
    required super.hasMore,
    required super.firstId,
    required super.lastId,
  });

  factory ConferencePaginationModel.fromJson(Map<String, dynamic> json) {
    return ConferencePaginationModel(
      hasMore: json['has_more'],
      firstId: json['first_id'],
      lastId: json['last_id'],
    );
  }
}

abstract class ConferenceRemoteDataSource {
  Future<(List<ConferenceModel>, ConferencePagination)> getConferences({
    String? afterId,
    String? beforeId,
    required int limit,
    String? hostId,
    required String status,
    DateTime? startsBefore,
    DateTime? startsAfter,
    bool? includePast,
    required String orderBy,
    required String order,
    String? title,
  });

  Future<ConferenceModel> getConferenceById(String id);
}

class ConferenceRemoteDataSourceImpl implements ConferenceRemoteDataSource {
  final ApiClient client;
  ConferenceRemoteDataSourceImpl({required this.client});

  @override
  Future<(List<ConferenceModel>, ConferencePagination)> getConferences({
    String? afterId,
    String? beforeId,
    required int limit,
    String? hostId,
    required String status,
    DateTime? startsBefore,
    DateTime? startsAfter,
    bool? includePast,
    required String orderBy,
    required String order,
    String? title,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'status': status,
      'order_by': orderBy,
      'order': order,
    };
    if (afterId != null) queryParams['after_id'] = afterId;
    if (beforeId != null) queryParams['before_id'] = beforeId;
    if (hostId != null && hostId.isNotEmpty) queryParams['host_id'] = hostId;
    if (startsBefore != null) queryParams['starts_before'] = startsBefore.toIso8601String();
    if (startsAfter != null) queryParams['starts_after'] = startsAfter.toIso8601String();
    if (includePast != null) queryParams['include_past'] = includePast;
    if (title != null && title.isNotEmpty) queryParams['title'] = title;

    final response = await client.get(
      '/conferences',
      queryParameters: queryParams,
      requireAuth: true,
    );

    final confs = (response['conferences'] as List)
        .map((j) => ConferenceModel.fromJson(j))
        .toList();
    final pagination = ConferencePaginationModel.fromJson(response['pagination']);
    return (confs, pagination);
  }

  @override
  Future<ConferenceModel> getConferenceById(String id) async {
    final response = await client.get('/conferences/$id', requireAuth: true);
    return ConferenceModel.fromJson(response['conference']);
  }
}
