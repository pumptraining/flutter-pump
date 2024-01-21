import 'package:flutter/material.dart';

class TagModel {
  final String? id;
  final String title;
  final Color color;
  bool isSelected;

  TagModel({
    this.id,
    required this.title,
    required this.color,
    required this.isSelected,
  });
}