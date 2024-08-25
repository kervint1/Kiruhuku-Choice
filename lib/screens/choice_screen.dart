import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ChoiceScreen extends StatefulWidget {
  final String city;
  final String season;

  const ChoiceScreen({super.key, required this.city, required this.season});

  @override
  _ChoiceScreenState createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  String weather = "Loading...";
  String temperature = "";
  Map<String, Map<String, dynamic>> selectedItems = {};

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.city);
    fetchItems();
  }

  Future<void> fetchWeather(String cityName) async {
    const apiKey = 'e685277d11e2b1fcba6e4fe404fee4db'; // APIキーをここに入力
    final apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          weather = data['weather'][0]['description'];
          temperature = "${data['main']['temp']}°C";
        });
      } else {
        setState(() {
          weather = "Failed to load data";
        });
      }
    } catch (e) {
      setState(() {
        weather = "Error: $e";
      });
    }
  }

  Future<void> fetchItems() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final File dataFile = File('${appDir.path}/clothes_data.json');

      if (await dataFile.exists()) {
        String contents = await dataFile.readAsString();
        List<dynamic> data = json.decode(contents);

        final filteredItems = data.where((item) {
          return item['seasons'].contains(widget.season);
        }).toList();

        final random = Random();
        final selectedItems = <String, Map<String, dynamic>>{};

        for (var category in [
          'トップス',
          'パンツ',
          'ジャケット・アウター',
          '靴下',
          'シューズ',
          'アクセサリー',
          'バッグ'
        ]) {
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
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
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
                    '都市: ${widget.city}', // 英語の都市名を表示
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
