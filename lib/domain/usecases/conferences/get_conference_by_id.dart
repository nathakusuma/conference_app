import '../../entities/conference.dart';
import '../../repositories/conference_repository.dart';

class GetConferenceById {
  final ConferenceRepository repository;
  GetConferenceById(this.repository);

  Future<Conference> call(String id) => repository.getConferenceById(id);
}
