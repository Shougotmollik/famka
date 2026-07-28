import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String title;
  final String iconAsset;
  final Color badgeColor;
  final bool isUnlocked;

  const BadgeModel({
    required this.id,
    required this.title,
    required this.iconAsset,
    required this.badgeColor,
    required this.isUnlocked,
  });
}
