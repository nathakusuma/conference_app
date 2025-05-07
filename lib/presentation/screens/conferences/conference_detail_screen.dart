import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../providers/conference_detail_provider.dart';

class ConferenceDetailScreen extends StatelessWidget {
  final String conferenceId;
  static Route route({required String id}) =>
      MaterialPageRoute(builder: (_) => ConferenceDetailScreen(conferenceId: id));

  const ConferenceDetailScreen({required this.conferenceId, Key? key})
      : super(key: key);

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
        );
      },
    );
  }
}
