// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) => Trip(
      id: json['id'] as String?,
      name: json['name'] as String,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'events': instance.events.map((e) => e.toJson()).toList(),
    };
