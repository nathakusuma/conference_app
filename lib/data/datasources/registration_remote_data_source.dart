import '../../core/network/api_client.dart';
import '../../domain/entities/conference.dart';
import '../models/conference_model.dart';
import 'conference_remote_data_source.dart';

abstract class RegistrationRemoteDataSource {
  Future<(List<ConferenceModel>, ConferencePagination)> getUserRegistrations({
    String? afterId,
    String? beforeId,
    required int limit,
    required bool includePast,
  });

  Future<void> registerForConference(String conferenceId);
}

class RegistrationRemoteDataSourceImpl implements RegistrationRemoteDataSource {
  final ApiClient client;

  RegistrationRemoteDataSourceImpl({required this.client});

  @override
  Future<(List<ConferenceModel>, ConferencePagination)> getUserRegistrations({
    String? afterId,
    String? beforeId,
    required int limit,
    required bool includePast,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'include_past': includePast,
    };

    if (afterId != null) queryParams['after_id'] = afterId;
    if (beforeId != null) queryParams['before_id'] = beforeId;

    final response = await client.get(
      '/registrations/users/me',
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
  Future<void> registerForConference(String conferenceId) async {
    await client.post(
      '/registrations',
      data: {'conference_id': conferenceId},
      requireAuth: true,
    );
  }
}
