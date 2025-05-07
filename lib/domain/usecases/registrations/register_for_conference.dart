import '../../repositories/registration_repository.dart';

class RegisterForConference {
  final RegistrationRepository repository;

  RegisterForConference(this.repository);

  Future<void> call(String conferenceId) {
    return repository.registerForConference(conferenceId);
  }
}
