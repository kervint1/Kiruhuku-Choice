import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ClothesListScreen extends StatefulWidget {
  const ClothesListScreen({super.key});

  @override
  ClothesListScreenState createState() => ClothesListScreenState();
}

class ClothesListScreenState extends State<ClothesListScreen> {
  List<Map<String, dynamic>> _clothesList = [];

  @override
  void initState() {
    super.initState();
    _loadClothesData();
  }

  Future<void> _loadClothesData() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File dataFile = File('${appDir.path}/clothes_data.json');

      if (await dataFile.exists()) {
        String contents = await dataFile.readAsString();
        List<dynamic> data = json.decode(contents);

        if (mounted) {
          setState(() {
            _clothesList = List<Map<String, dynamic>>.from(data);
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('保存された服のデータがありません')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('データの読み込み中にエラーが発生しました: $e')),
        );
      }
    }
  }

  // 特定のインデックスの服を取得する関数
  Map<String, dynamic>? getClothingItemByIndex(int index) {
    if (index >= 0 && index < _clothesList.length) {
      return _clothesList[index];
    }
    return null;
  }

  // 特定の季節と種類に基づいて服をフィルタリングする関数
  List<Map<String, dynamic>> getClothesBySeasonAndType(
      String season, String type) {
    return _clothesList.where((item) {
      return item['type'] == type && item['seasons'].contains(season);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録された服リスト'),
      ),
      body: _clothesList.isNotEmpty
          ? ListView.builder(
              itemCount: _clothesList.length,
              itemBuilder: (context, index) {
                final clothes = _clothesList[index];
                final clothesType = clothes['type'] as String?;
                final imagePath = clothes['imagePath'] as String?;
                final seasons = clothes['seasons'] as List<dynamic>?;

                // Nullチェックを追加
                if (clothesType == null ||
                    imagePath == null ||
                    seasons == null) {
                  return const SizedBox.shrink(); // 空のウィジェットを返す
                }

                return Card(
                  child: ListTile(
                    leading: Image.file(
                      File(imagePath),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(clothesType),
                    subtitle: Text('シーズン: ${seasons.join(', ')}'),
                    onTap: () {
                      // 詳細画面などに遷移する場合はここで処理を行う
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('服のデータがありません'),
            ),
    );
  }
}
