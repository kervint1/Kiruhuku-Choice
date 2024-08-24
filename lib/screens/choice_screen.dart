import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChoiceScreen extends StatefulWidget {
  final String city;

  const ChoiceScreen({super.key, required this.city});

  @override
  _ChoiceScreenState createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  String weather = "Loading...";
  String temperature = "";

  @override
  void initState() {
    super.initState();
    fetchWeather(widget.city);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("チョイス先"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '都市: ${widget.city}',
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
    );
  }
}
