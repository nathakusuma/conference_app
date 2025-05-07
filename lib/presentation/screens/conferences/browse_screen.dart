import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/conference.dart';
import '../../providers/browse_provider.dart';
import 'conference_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  static const routeName = '/browse';

  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _searchController = TextEditingController();
  String _search = "";
  DateTime? _startsBefore;
  DateTime? _startsAfter;
  bool _includePast = false;
  String _orderBy = 'starts_at';
  String _order = 'asc';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrowseProvider>(context, listen: false).refresh();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _filtersSection(BrowseProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by title...',
                  border: OutlineInputBorder(),
                  isDense: true,
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (v) {
                  setState(() => _search = v.trim());
                  provider.setFilters(title: v.trim());
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: () => _showFilterDialog(context, provider),
            ),
          ],
        ),
        if (_startsBefore != null || _startsAfter != null || _includePast || _orderBy != 'starts_at' || _order != 'asc')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (_startsBefore != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text("Before: ${DateFormatter.formatDate(_startsBefore!)}"),
                        onDeleted: () {
                          setState(() => _startsBefore = null);
                          provider.setFilters(startsBefore: null);
                        },
                      ),
                    ),
                  if (_startsAfter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text("After: ${DateFormatter.formatDate(_startsAfter!)}"),
                        onDeleted: () {
                          setState(() => _startsAfter = null);
                          provider.setFilters(startsAfter: null);
                        },
                      ),
                    ),
                  if (_includePast)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: const Text("Including past"),
                        onDeleted: () {
                          setState(() => _includePast = false);
                          provider.setFilters(includePast: false);
                        },
                      ),
                    ),
                  if (_orderBy != 'starts_at' || _order != 'asc')
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text("Order: ${_orderBy == 'starts_at' ? 'Date' : 'Created'} ${_order == 'asc' ? '↑' : '↓'}"),
                        onDeleted: () {
                          setState(() {
                            _orderBy = 'starts_at';
                            _order = 'asc';
                          });
                          provider.setFilters(orderBy: 'starts_at', order: 'asc');
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _showFilterDialog(BuildContext context, BrowseProvider provider) async {
    DateTime? tempStartsBefore = _startsBefore;
    DateTime? tempStartsAfter = _startsAfter;
    bool tempIncludePast = _includePast;
    String tempOrderBy = _orderBy;
    String tempOrder = _order;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: const Text('Filter Conferences'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  title: const Text('Starts after'),
                  subtitle: tempStartsAfter != null
                      ? Text(DateFormatter.formatDate(tempStartsAfter!))
                      : const Text('Not set'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: tempStartsAfter ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setStateDialog(() => tempStartsAfter = date);
                      }
                    },
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: tempStartsAfter ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setStateDialog(() => tempStartsAfter = date);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Starts before'),
                  subtitle: tempStartsBefore != null
                      ? Text(DateFormatter.formatDate(tempStartsBefore!))
                      : const Text('Not set'),
                  trailing: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: tempStartsBefore ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        setStateDialog(() => tempStartsBefore = date);
                      }
                    },
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: tempStartsBefore ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setStateDialog(() => tempStartsBefore = date);
                    }
                  },
                ),
                SwitchListTile(
                  title: const Text('Include past conferences'),
                  value: tempIncludePast,
                  onChanged: (value) {
                    setStateDialog(() => tempIncludePast = value);
                  },
                ),
                const Divider(),
                const Text('Sorting', style: TextStyle(fontWeight: FontWeight.bold)),
                RadioListTile<String>(
                  title: const Text('Order by date'),
                  value: 'starts_at',
                  groupValue: tempOrderBy,
                  onChanged: (value) {
                    setStateDialog(() => tempOrderBy = value!);
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Order by created date'),
                  value: 'created_at',
                  groupValue: tempOrderBy,
                  onChanged: (value) {
                    setStateDialog(() => tempOrderBy = value!);
                  },
                ),
                const Divider(),
                const Text('Direction', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('Ascending'),
                      selected: tempOrder == 'asc',
                      onSelected: (selected) {
                        if (selected) {
                          setStateDialog(() => tempOrder = 'asc');
                        }
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Descending'),
                      selected: tempOrder == 'desc',
                      onSelected: (selected) {
                        if (selected) {
                          setStateDialog(() => tempOrder = 'desc');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _startsBefore = tempStartsBefore;
                  _startsAfter = tempStartsAfter;
                  _includePast = tempIncludePast;
                  _orderBy = tempOrderBy;
                  _order = tempOrder;
                });
                provider.setFilters(
                  startsBefore: tempStartsBefore,
                  startsAfter: tempStartsAfter,
                  includePast: tempIncludePast,
                  orderBy: tempOrderBy,
                  order: tempOrder,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conference App'),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<BrowseProvider>(
        builder: (context, provider, child) {
          final confs = provider.conferences;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _filtersSection(provider),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refresh,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notif) {
                      if (notif.metrics.pixels >= notif.metrics.maxScrollExtent - 200
                          && !provider.isLoading
                          && provider.hasMore) {
                        provider.fetch();
                      }
                      return false;
                    },
                    child: confs.isEmpty && !provider.isLoading
                        ? const Center(child: Text('No conferences found'))
                        : ListView.builder(
                      itemCount: confs.length + (provider.hasMore || provider.isLoading ? 1 : 0),
                      itemBuilder: (context, idx) {
                        if (idx >= confs.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final conf = confs[idx];
                        return _buildConferenceCard(conf, () {
                          Navigator.of(context).push(
                            ConferenceDetailScreen.route(id: conf.id),
                          );
                        });
                      },
                    ),
                  ),
                ),
              ),
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
