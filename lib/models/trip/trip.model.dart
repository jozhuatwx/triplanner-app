import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../event/event.model.dart';

part 'trip.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Trip {
  late String id;
  late String name;
  late DateTime startDate;
  late DateTime endDate;
  late List<Event> events;

  Trip({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    List<Event>? events,
  }) {
    this.id = id ?? const Uuid().v4();
    this.name = name ?? '';
    this.startDate = startDate ?? DateTime.now();
    this.endDate = endDate ?? DateTime.now();
    this.events = events ?? [];
  }

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  static List<Trip> fromJsonList(dynamic json) =>
      json.map<Trip>((e) => _$TripFromJson(e)).toList();
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
