import '../../domain/entities/conference.dart';
import '../../domain/repositories/conference_repository.dart';
import '../datasources/conference_remote_data_source.dart';

class ConferenceRepositoryImpl implements ConferenceRepository {
  final ConferenceRemoteDataSource remoteDataSource;
  ConferenceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(List<Conference>, ConferencePagination)> getConferences({
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
  }) =>
      remoteDataSource.getConferences(
        afterId: afterId,
        beforeId: beforeId,
        limit: limit,
        hostId: hostId,
        status: status,
        startsBefore: startsBefore,
        startsAfter: startsAfter,
        includePast: includePast,
        orderBy: orderBy,
        order: order,
        title: title,
      );

  @override
  Future<Conference> getConferenceById(String id) =>
      remoteDataSource.getConferenceById(id);
}
