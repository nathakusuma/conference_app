import '../../entities/conference.dart';
import '../../repositories/registration_repository.dart';

class GetUserRegistrations {
  final RegistrationRepository repository;

  GetUserRegistrations(this.repository);

  Future<(List<Conference>, ConferencePagination)> call({
    String? afterId,
    String? beforeId,
    required int limit,
    required bool includePast,
  }) {
    return repository.getUserRegistrations(
      afterId: afterId,
      beforeId: beforeId,
      limit: limit,
      includePast: includePast,
    );
  }
}
