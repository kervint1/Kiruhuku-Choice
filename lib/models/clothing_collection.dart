// lib/models/clothing_collection.dart
import 'clothing_item.dart';

class ClothingCollection {
  final List<ClothingItem> _clothingItems = [];

  void addClothingItem(ClothingItem item) {
    _clothingItems.add(item);
  }

  List<ClothingItem> get items => _clothingItems;

  List<ClothingItem> get tops {
    return _clothingItems.where((item) => item.type == 'トップス').toList();
  }

  // その他のカテゴリも同様

  List<ClothingItem> filterBySeason(String season) {
    return _clothingItems.where((item) => item.isForSeason(season)).toList();
  }

  List<ClothingItem> filterByTemperature(int minTemp) {
    return _clothingItems
        .where((item) => item.temperature.minTemp <= minTemp)
        .toList();
  }

  List<Map<String, dynamic>> toJson() {
    return _clothingItems.map((item) => item.toJson()).toList();
  }

  void fromJson(List<dynamic> jsonList) {
    _clothingItems.clear();
    _clothingItems.addAll(
        jsonList.map((jsonItem) => ClothingItem.fromJson(jsonItem)).toList());
  }
}
