import '../entities/conference.dart';

abstract class ConferenceRepository {
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
  });

  Future<Conference> getConferenceById(String id);
}
