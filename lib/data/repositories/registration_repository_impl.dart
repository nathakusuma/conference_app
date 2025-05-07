import '../../domain/entities/conference.dart';
import '../../domain/repositories/registration_repository.dart';
import '../datasources/registration_remote_data_source.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(List<Conference>, ConferencePagination)> getUserRegistrations({
    String? afterId,
    String? beforeId,
    required int limit,
    required bool includePast,
  }) {
    return remoteDataSource.getUserRegistrations(
      afterId: afterId,
      beforeId: beforeId,
      limit: limit,
      includePast: includePast,
    );
  }

  @override
  Future<void> registerForConference(String conferenceId) {
    return remoteDataSource.registerForConference(conferenceId);
  }
}
