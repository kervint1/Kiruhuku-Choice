import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Testpage extends StatefulWidget {
  const Testpage({super.key});

  @override
  TestpageState createState() => TestpageState();
}

class TestpageState extends State<Testpage> {
  List<Map<String, dynamic>> springOuterwear = [];

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

        final filteredData = data.where((item) {
          return item['type'] == 'トップス' && item['seasons'].contains('春');
        }).toList();

        setState(() {
          springOuterwear = List<Map<String, dynamic>>.from(filteredData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('春のトップス'),
      ),
      body: springOuterwear.isNotEmpty
          ? ListView.builder(
              itemCount: springOuterwear.length,
              itemBuilder: (context, index) {
                final clothes = springOuterwear[index];
                return ListTile(
                  title: Text(clothes['type']),
                  subtitle: Text('シーズン: ${clothes['seasons'].join(', ')}'),
                  leading: Image.file(
                    File(clothes['imagePath']),
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          : const Center(
              child: Text('春のトップスがありません'),
            ),
    );
  }
}
