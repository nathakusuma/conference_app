class Conference {
  final String id;
  final String title;
  final String description;
  final String speakerName;
  final String speakerTitle;
  final String targetAudience;
  final String? prerequisites;
  final int seats;
  final DateTime startsAt;
  final DateTime endsAt;
  final Host host;
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? seatsTaken;

  Conference({
    required this.id,
    required this.title,
    required this.description,
    required this.speakerName,
    required this.speakerTitle,
    required this.targetAudience,
    this.prerequisites,
    required this.seats,
    required this.startsAt,
    required this.endsAt,
    required this.host,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.seatsTaken,
  });
}

class Host {
  final String id;
  final String name;

  Host({required this.id, required this.name});
}

class ConferencePagination {
  final bool hasMore;
  final String? firstId;
  final String? lastId;

  ConferencePagination({required this.hasMore, this.firstId, this.lastId});
}
