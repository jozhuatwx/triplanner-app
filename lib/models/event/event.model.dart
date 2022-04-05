import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'event_type.enum.dart';

part 'event.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Event {
  late String id;
  String name;
  late EventType type;
  DateTime startDateTime;
  DateTime endDateTime;

  String? location;
  double? latitude;
  double? longitude;
  String? note;

  Event(
      {String? id,
      required this.name,
      EventType? type,
      required this.startDateTime,
      required this.endDateTime,
      this.location,
      this.latitude,
      this.longitude,
      this.note}) {
    this.id = id ?? const Uuid().v4();
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  static List<Event> fromJsonList(List json) =>
      json.map((e) => _$EventFromJson(e)).toList();
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
