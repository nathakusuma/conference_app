import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/conference.dart';
import '../../providers/registrations_provider.dart';
import '../conferences/conference_detail_screen.dart';

class RegistrationsScreen extends StatefulWidget {
  static const routeName = '/registrations';

  const RegistrationsScreen({super.key});

  @override
  State<RegistrationsScreen> createState() => _RegistrationsScreenState();
}

class _RegistrationsScreenState extends State<RegistrationsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<RegistrationsProvider>(context, listen: false);
    provider.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Registrations'),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<RegistrationsProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: provider.isLoading ? null : provider.refresh,
              );
            },
          ),
        ],
      ),
      body: Consumer<RegistrationsProvider>(
        builder: (context, provider, child) {
          final registrations = provider.registrations;

          return Column(
            children: [
              // Filter section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SwitchListTile(
                    title: const Text('Include past conferences'),
                    value: provider.includePast,
                    onChanged: (value) {
                      provider.setIncludePast(value);
                    },
                  ),
                ),
              ),

              // List of registrations
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notif) {
                      if (notif.metrics.pixels >= notif.metrics.maxScrollExtent - 200 &&
                          !provider.isLoading &&
                          provider.hasMore) {
                        provider.fetch();
                      }
                      return false;
                    },
                    child: registrations.isEmpty && !provider.isLoading
                        ? const Center(child: Text('No registrations found'))
                        : ListView.builder(
                      itemCount: registrations.length +
                          (provider.hasMore || provider.isLoading ? 1 : 0),
                      itemBuilder: (context, idx) {
                        if (idx >= registrations.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final conf = registrations[idx];
                        return _buildConferenceCard(conf, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ConferenceDetailScreen(
                                conferenceId: conf.id,
                                isRegistered: true,
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),

              // Error message
              if (provider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    provider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConferenceCard(Conference conf, VoidCallback onTap) {
    final seatsInfo = conf.seatsTaken != null
        ? "${conf.seatsTaken}/${conf.seats} seats"
        : "${conf.seats} seats";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(conf.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Speaker: ${conf.speakerName} (${conf.speakerTitle})"),
            Text("Audience: ${conf.targetAudience}"),
            Text("Seats: $seatsInfo"),
            Text("Starts: ${DateFormatter.formatDateTime(conf.startsAt)}"),
            Text("Ends: ${DateFormatter.formatDateTime(conf.endsAt)}"),
          ],
        ),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
