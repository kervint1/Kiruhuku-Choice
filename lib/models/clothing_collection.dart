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

  List<ClothingItem> get pants {
    return _clothingItems.where((item) => item.type == 'パンツ').toList();
  }

  List<ClothingItem> get jackets {
    return _clothingItems.where((item) => item.type == 'ジャケット・アウター').toList();
  }

  List<ClothingItem> get socks {
    return _clothingItems.where((item) => item.type == '靴下').toList();
  }

  List<ClothingItem> get shoes {
    return _clothingItems.where((item) => item.type == 'シューズ').toList();
  }

  List<ClothingItem> get accessories {
    return _clothingItems.where((item) => item.type == 'アクセサリー').toList();
  }

  List<ClothingItem> get bags {
    return _clothingItems.where((item) => item.type == 'バッグ').toList();
  }

  List<ClothingItem> filterBySeason(String season) {
    return _clothingItems.where((item) => item.isForSeason(season)).toList();
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
