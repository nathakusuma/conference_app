import '../../domain/entities/conference.dart';

class ConferenceModel extends Conference {
  ConferenceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.speakerName,
    required super.speakerTitle,
    required super.targetAudience,
    super.prerequisites,
    required super.seats,
    required super.startsAt,
    required super.endsAt,
    required HostModel super.host,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.seatsTaken,
  });

  factory ConferenceModel.fromJson(Map<String, dynamic> json) {
    return ConferenceModel(
      id: json['id'],
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      speakerName: json['speaker_name'] ?? "",
      speakerTitle: json['speaker_title'] ?? "",
      targetAudience: json['target_audience'] ?? "",
      prerequisites: json['prerequisites'],
      seats: json['seats'],
      startsAt: DateTime.parse(json['starts_at']),
      endsAt: DateTime.parse(json['ends_at']),
      host: HostModel.fromJson(json['host']),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      seatsTaken: json['seats_taken'],
    );
  }
}

class HostModel extends Host {
  HostModel({
    required super.id,
    required super.name,
  });

  factory HostModel.fromJson(Map<String, dynamic> json) {
    return HostModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
