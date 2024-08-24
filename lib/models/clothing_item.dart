// lib/models/clothing_item.dart
import 'dart:io';
import 'temperature_model.dart';

class ClothingItem {
  final String type;
  final List<String> seasons;
  final String imagePath;
  final TemperatureModel temperature; // 温度モデルを追加

  ClothingItem({
    required this.type,
    required this.seasons,
    required this.imagePath,
    required this.temperature, // コンストラクタに温度モデルを追加
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
      'temperature': temperature.toJson(), // 温度モデルをJSONに追加
    };
  }

  static ClothingItem fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      type: json['type'],
      seasons: List<String>.from(json['seasons']),
      imagePath: json['imagePath'],
      temperature:
          TemperatureModel.fromJson(json['temperature']), // 温度モデルのデシリアライズ
    );
  }
}
