// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDetails _$PersonalDetailsFromJson(Map<String, dynamic> json) =>
    PersonalDetails(
      json['personal'] == null
          ? null
          : Personal.fromJson(json['personal'] as Map<String, dynamic>),
      (json['workoutSheets'] as List<dynamic>?)
          ?.map((e) => WorkoutSheets.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PersonalDetailsToJson(PersonalDetails instance) =>
    <String, dynamic>{
      'personal': instance.personal,
      'workoutSheets': instance.workoutSheets,
    };

Personal _$PersonalFromJson(Map<String, dynamic> json) => Personal(
      json['personalId'] as String?,
      json['name'] as String?,
      json['imageUrl'] as String?,
      json['instagramUrl'] as String?,
      json['description'] as String?,
      json['instagramUsername'] as String?,
    );

Map<String, dynamic> _$PersonalToJson(Personal instance) => <String, dynamic>{
      'personalId': instance.personalId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'instagramUrl': instance.instagramUrl,
    };

WorkoutSheets _$WorkoutSheetsFromJson(Map<String, dynamic> json) =>
    WorkoutSheets(
      json['workoutId'] as String?,
      json['title'] as String?,
      json['level'] as String?,
      json['imageUrl'] as String?,
      json['forwardUri'] as String?,
      json['description'] as String?,
      (json['amount'] as num?)?.toDouble(),
      json['personalId'] as String?,
      json['workoutShortDescription'] as String?,
    );

Map<String, dynamic> _$WorkoutSheetsToJson(WorkoutSheets instance) =>
    <String, dynamic>{
      'workoutId': instance.workoutId,
      'title': instance.title,
      'level': instance.level,
      'imageUrl': instance.imageUrl,
      'forwardUri': instance.forwardUri,
      'description': instance.description,
      'amount': instance.amount,
      'personalId': instance.personalId,
      'workoutShortDescription': instance.workoutShortDescription,
    };
