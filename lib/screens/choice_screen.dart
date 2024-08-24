import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ChoiceScreen extends StatefulWidget {
  final String city; // ここで city を定義
  final String season; // ここで season を定義

  const ChoiceScreen({super.key, required this.city, required this.season});

  @override
  _ChoiceScreenState createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  Map<String, Map<String, dynamic>> selectedItems = {};
  final List<String> categories = [
    'トップス',
    'パンツ',
    'ジャケット・アウター',
    '靴下',
    'シューズ',
    'アクセサリー',
    'バッグ'
  ];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File dataFile = File('${appDir.path}/clothes_data.json');

      if (await dataFile.exists()) {
        String contents = await dataFile.readAsString();
        List<dynamic> data = json.decode(contents);

        final filteredItems = data.where((item) {
          return item['seasons'].contains(widget.season); // widget.season を使用
        }).toList();

        final random = Random();
        final selectedItems = <String, Map<String, dynamic>>{};

        for (var category in categories) {
          final itemsInCategory = filteredItems.where((item) => item['type'] == category).toList();
          if (itemsInCategory.isNotEmpty) {
            final randomIndex = random.nextInt(itemsInCategory.length);
            selectedItems[category] = itemsInCategory[randomIndex];
          } else {
            selectedItems[category] = {'message': '保存されたデータがありませんでした'};
          }
        }

        setState(() {
          this.selectedItems = selectedItems;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存された服のデータがありません')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('データの読み込み中にエラーが発生しました: $e')),
      );
    }
  }

  void _reselectItems() {
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    // 仮の天気と温度データ
    final String weather = '晴れ';
    final String temperature = '25°C';

    return Scaffold(
      appBar: AppBar(
        title: const Text('チョイスリザルト！'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 都市、季節、天気、温度を表示
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '都市: ${widget.city}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '季節: ${widget.season}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '天気: $weather',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    '温度: $temperature',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            // カテゴリごとのアイテム表示
            ...selectedItems.entries.map((entry) {
              final category = entry.key;
              final item = entry.value;

              if (item.containsKey('message')) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$category: ${item['message']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        category,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Image.file(
                        File(item['imagePath']),
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                );
              }
            }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _reselectItems,
                child: const Text('再チョイス！'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
