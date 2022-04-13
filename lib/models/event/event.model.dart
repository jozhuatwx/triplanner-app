import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'event.model.g.dart';

enum EventType { flight, accommodation, destination, meal }

@JsonSerializable(explicitToJson: true)
class Event {
  late String id;
  String name;
  late EventType type;

  DateTime? startDateTime;
  DateTime? endDateTime;
  String? location;
  double? latitude;
  double? longitude;
  String? note;

  Event({
    String? id,
    required this.name,
    EventType? type,
    this.startDateTime,
    this.endDateTime,
    this.location,
    this.latitude,
    this.longitude,
    this.note,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  static List<Event> fromJsonList(dynamic json) =>
      json.map<Event>((e) => _$EventFromJson(e)).toList();
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
