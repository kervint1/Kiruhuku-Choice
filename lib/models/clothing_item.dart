// lib/models/clothing_item.dart
import 'dart:io';

class ClothingItem {
  final String type;
  final List<String> seasons;
  final String imagePath;

  ClothingItem({
    required this.type,
    required this.seasons,
    required this.imagePath,
  });

  File get imageFile => File(imagePath);

  bool isForSeason(String season) {
    return seasons.contains(season);
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'seasons': seasons,
      'imagePath': imagePath,
    };
  }

  static ClothingItem fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      type: json['type'],
      seasons: List<String>.from(json['seasons']),
      imagePath: json['imagePath'],
    );
  }
}
