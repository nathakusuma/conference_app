import '../../entities/conference.dart';
import '../../repositories/conference_repository.dart';

class GetConferences {
  final ConferenceRepository repository;
  GetConferences(this.repository);

  Future<(List<Conference>, ConferencePagination)> call({
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
  }) {
    return repository.getConferences(
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
  }
}
