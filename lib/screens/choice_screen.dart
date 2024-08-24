import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<Map<String, dynamic>> selectedItems = [];

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
    // 仮のデータとして JSON データを使っています。実際には、API からデータを取得するなどして、下記のようなアイテムのリストを取得することを想定しています。
    final List<Map<String, dynamic>> allItems = [
      {'type': 'トップス', 'season': '春', 'imagePath': 'https://example.com/image1.jpg'},
      {'type': 'パンツ', 'season': '春', 'imagePath': 'https://example.com/image2.jpg'},
      {'type': 'ジャケット・アウター', 'season': '春', 'imagePath': 'https://example.com/image3.jpg'},
      {'type': '靴下', 'season': '春', 'imagePath': 'https://example.com/image4.jpg'},
      {'type': 'シューズ', 'season': '春', 'imagePath': 'https://example.com/image5.jpg'},
      {'type': 'アクセサリー', 'season': '春', 'imagePath': 'https://example.com/image6.jpg'},
      {'type': 'バッグ', 'season': '春', 'imagePath': 'https://example.com/image7.jpg'},
    ];

    final filteredItems = allItems.where((item) {
      return item['season'] == widget.season;
    }).toList();

    final random = Random();

    // 各カテゴリからランダムに1つのアイテムを選択します
    final categories = ['トップス', 'パンツ', 'ジャケット・アウター', '靴下', 'シューズ', 'アクセサリー', 'バッグ'];
    final selectedItems = <Map<String, dynamic>>[];

    for (var category in categories) {
      final itemsInCategory = filteredItems.where((item) => item['type'] == category).toList();
      if (itemsInCategory.isNotEmpty) {
        final randomIndex = random.nextInt(itemsInCategory.length);
        selectedItems.add(itemsInCategory[randomIndex]); // ランダムなアイテムを選択します
      }
    }

    setState(() {
      this.selectedItems = selectedItems;
    });
  }

  void _reselectItems() {
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("チョイス先"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ...selectedItems.map((item) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      item['type'],
                      style: const TextStyle(fontSize: 18),
                    ),
                    Image.network(
                      item['imagePath'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _reselectItems,
                child: const Text('再チョイス'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
