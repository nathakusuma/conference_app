import '../entities/conference.dart';

abstract class RegistrationRepository {
  Future<(List<Conference>, ConferencePagination)> getUserRegistrations({
    String? afterId,
    String? beforeId,
    required int limit,
    required bool includePast,
  });

  Future<void> registerForConference(String conferenceId);
}
