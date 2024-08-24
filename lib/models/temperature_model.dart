// lib/models/temperature_model.dart
class TemperatureModel {
  final String label;
  final int minTemp;

  TemperatureModel({required this.label, required this.minTemp});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'minTemp': minTemp,
    };
  }

  static TemperatureModel fromJson(Map<String, dynamic> json) {
    return TemperatureModel(
      label: json['label'],
      minTemp: json['minTemp'],
    );
  }
}
