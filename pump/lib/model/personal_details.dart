import 'package:json_annotation/json_annotation.dart';

part 'personal_details.g.dart'; // Nome do arquivo que o json_serializable irá gerar

@JsonSerializable()
class PersonalDetails {
  Personal? personal;
  List<WorkoutSheets>? workoutSheets;

  PersonalDetails(
    this.personal,
    this.workoutSheets,
  );

  factory PersonalDetails.fromJson(Map<String, dynamic> json) =>
      _$PersonalDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalDetailsToJson(this);
}

@JsonSerializable()
class Personal {
  String? personalId;
  String? name;
  String? imageUrl;
  String? instagramUrl;
  String? description;
  String? instagramUsername;

  Personal(
    this.personalId,
    this.name,
    this.imageUrl,
    this.instagramUrl,
    this.description,
    this.instagramUsername,
  );

  factory Personal.fromJson(Map<String, dynamic> json) =>
      _$PersonalFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalToJson(this);
}

@JsonSerializable()
class WorkoutSheets {

  String? workoutId;
  String? title;
  String? level;
  String? imageUrl;
  String? forwardUri;
  String? description;
  double? amount;
  String? personalId;
  String? workoutShortDescription;

  WorkoutSheets(
    this.workoutId,
    this.title,
    this.level,
    this.imageUrl,
    this.forwardUri,
    this.description,
    this.amount,
    this.personalId,
    this.workoutShortDescription,
  );

  factory WorkoutSheets.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSheetsFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSheetsToJson(this);
}
