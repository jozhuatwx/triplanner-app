// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: json['id'] as String?,
      name: json['name'] as String,
      type: $enumDecodeNullable(_$EventTypeEnumMap, json['type']),
      startDateTime: json['startDateTime'] == null
          ? null
          : DateTime.parse(json['startDateTime'] as String),
      endDateTime: json['endDateTime'] == null
          ? null
          : DateTime.parse(json['endDateTime'] as String),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$EventTypeEnumMap[instance.type],
      'startDateTime': instance.startDateTime?.toIso8601String(),
      'endDateTime': instance.endDateTime?.toIso8601String(),
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'note': instance.note,
    };

const _$EventTypeEnumMap = {
  EventType.flight: 'flight',
  EventType.accommodation: 'accommodation',
  EventType.destination: 'destination',
  EventType.meal: 'meal',
};
