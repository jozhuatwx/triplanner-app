import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../event/event.model.dart';

part 'trip.model.g.dart';

@JsonSerializable(explicitToJson: true)
class Trip {
  late String id;
  late String name;
  late List<Event> events;

  DateTime? startDate;
  DateTime? endDate;

  Trip({String? id, String? name, List<Event>? events}) {
    this.id = id ?? const Uuid().v4();
    this.name = name ?? '';
    this.events = events ?? [];
  }

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  static List<Trip> fromJsonList(List json) =>
      json.map((e) => _$TripFromJson(e)).toList();
  Map<String, dynamic> toJson() => _$TripToJson(this);
}
