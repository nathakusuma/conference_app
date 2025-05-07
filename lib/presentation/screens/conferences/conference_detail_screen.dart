import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/conference_detail_provider.dart';
import '../../providers/registration_action_provider.dart';

class ConferenceDetailScreen extends StatelessWidget {
  final String conferenceId;
  final bool isRegistered;

  static Route route({required String id, bool isRegistered = false}) =>
      MaterialPageRoute(builder: (_) => ConferenceDetailScreen(
        conferenceId: id,
        isRegistered: isRegistered,
      ));

  const ConferenceDetailScreen({
    required this.conferenceId,
    this.isRegistered = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConferenceDetailProvider>(
      builder: (context, provider, child) {
        if (provider.conference == null && !provider.loading) {
          provider.fetch(conferenceId);
        }
        final conf = provider.conference;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Conference App'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: provider.loading
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!, style: const TextStyle(color: Colors.red)))
              : conf == null
              ? const Center(child: Text("Conference not found"))
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Text(conf.title,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text("Speaker: ${conf.speakerName} (${conf.speakerTitle})"),
                      Text("Audience: ${conf.targetAudience}"),
                      Text("Seats: ${conf.seatsTaken ?? 0}/${conf.seats}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Starts", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(DateFormatter.formatDate(conf.startsAt)),
                                    Text(DateFormatter.formatTime(conf.startsAt)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Ends", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(DateFormatter.formatDate(conf.endsAt)),
                                    Text(DateFormatter.formatTime(conf.endsAt)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(conf.description),
                      const SizedBox(height: 12),
                      if (conf.prerequisites != null && conf.prerequisites!.trim().isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Prerequisites:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(conf.prerequisites!),
                          ],
                        ),
                    ],
                  ),
                ),
                // Registration button if not already registered
                if (!isRegistered)
                  Consumer<RegistrationActionProvider>(
                    builder: (context, regProvider, _) {
                      if (regProvider.status == RegistrationStatus.success) {
                        // Reset after success
                        Future.delayed(Duration.zero, () {
                          regProvider.reset();
                          Navigator.of(context).pop(true); // Return true to indicate registration success
                        });
                      }

                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: regProvider.status == RegistrationStatus.loading
                                  ? null
                                  : () => _showRegisterDialog(context, regProvider, conf!.id),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: regProvider.status == RegistrationStatus.loading
                                  ? const CircularProgressIndicator()
                                  : const Text('Register for Conference'),
                            ),
                          ),
                          if (regProvider.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                regProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      );
                    },
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      color: Colors.green.shade50,
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'You are registered for this conference',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showRegisterDialog(
      BuildContext context,
      RegistrationActionProvider provider,
      String conferenceId,
      ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Register for Conference'),
        content: const Text('Are you sure you want to register for this conference?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Register'),
          ),
        ],
      ),
    );

    if (result == true) {
      await provider.registerForConference(conferenceId);
    }
  }
}
