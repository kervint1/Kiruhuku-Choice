import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class ClothesListScreen extends StatefulWidget {
  const ClothesListScreen({super.key});

  @override
  _ClothesListScreenState createState() => _ClothesListScreenState();
}

class _ClothesListScreenState extends State<ClothesListScreen> {
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

        setState(() {
          _clothesList = List<Map<String, dynamic>>.from(data);
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
        title: const Text('登録された服リスト'),
      ),
      body: _clothesList.isNotEmpty
          ? ListView.builder(
              itemCount: _clothesList.length,
              itemBuilder: (context, index) {
                final clothes = _clothesList[index];
                return Card(
                  child: ListTile(
                    leading: Image.file(
                      File(clothes['imagePath']),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(clothes['clothesType']),
                    subtitle: Text('シーズン: ${clothes['seasons'].join(', ')}'),
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
