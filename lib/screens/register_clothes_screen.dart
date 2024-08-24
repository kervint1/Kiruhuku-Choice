import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiruhuku_choice/models/clothing_collection.dart';
import 'package:kiruhuku_choice/models/clothing_item.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:go_router/go_router.dart';

class RegisterClothesScreen extends StatefulWidget {
  const RegisterClothesScreen({super.key});

  @override
  _RegisterClothesScreenState createState() => _RegisterClothesScreenState();
}

class _RegisterClothesScreenState extends State<RegisterClothesScreen> {
  File? _image;
  String? _selectedClothesType;
  final ImagePicker _picker = ImagePicker();
  final List<String> _selectedSeasons = [];
  final ClothingCollection _clothingCollection = ClothingCollection();

  final List<String> _clothesTypes = [
    'トップス',
    'パンツ',
    'ジャケット・アウター',
    '靴下',
    'シューズ',
    'アクセサリー',
    'バッグ',
  ];

  final List<String> _seasons = [
    '春',
    '夏',
    '秋',
    '冬',
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveData() async {
    if (_image == null ||
        _selectedClothesType == null ||
        _selectedSeasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('画像、服の種類、季節を選択してください')),
      );
      return;
    }

    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory clothesDir = Directory('${appDir.path}/clothes');
      if (!await clothesDir.exists()) {
        await clothesDir.create(recursive: true);
      }

      final String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          _image!.path.split('/').last;
      final File savedImage =
          await _image!.copy('${clothesDir.path}/$fileName');

      final ClothingItem newItem = ClothingItem(
        type: _selectedClothesType!,
        seasons: _selectedSeasons,
        imagePath: savedImage.path,
      );

      _clothingCollection.addClothingItem(newItem);

      final File dataFile = File('${appDir.path}/clothes_data.json');
      List<dynamic> existingData = [];
      if (await dataFile.exists()) {
        String contents = await dataFile.readAsString();
        existingData = json.decode(contents);
      }

      existingData.add(newItem.toJson());
      await dataFile.writeAsString(json.encode(existingData));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('服が正常に登録されました')),
      );

      setState(() {
        _image = null;
        _selectedClothesType = null;
        _selectedSeasons.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('データの保存中にエラーが発生しました: $e')),
      );
    }
  }

  void _onSeasonChanged(bool? value, String season) {
    setState(() {
      if (value == true) {
        _selectedSeasons.add(season);
      } else {
        _selectedSeasons.remove(season);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final pictureCon = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      height: screenHeight * 0.2,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _image != null
              ? Image.file(
                  _image!,
                  height: 100,
                )
              : const Text('画像が選択されていません'),
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('画像を選択'),
          ),
        ],
      ),
    );

    final clothesTypeCon = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      height: screenHeight * 0.4,
      width: double.infinity,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedClothesType,
              decoration: const InputDecoration(
                labelText: '服の種類を選択',
                border: OutlineInputBorder(),
              ),
              items: _clothesTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClothesType = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            Column(
              children: _seasons.map((String season) {
                return CheckboxListTile(
                  title: Text(season),
                  value: _selectedSeasons.contains(season),
                  onChanged: (bool? value) {
                    _onSeasonChanged(value, season);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );

    final registerbuttonCon = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      height: screenHeight * 0.2,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _saveData,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(300, 50),
            ),
            child: const Text("服登録ボタン"),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.push('/clothesList'); // GoRouterで画面遷移
            },
            child: const Text('登録された服を表示'),
          ),
        ],
      ),
    );

    final allObject = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [pictureCon, clothesTypeCon, registerbuttonCon],
    );

    final body = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      child: allObject,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        title: const Text('着る服チョイス'),
      ),
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
