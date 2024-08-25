import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _currentPosition = LatLng(35.681236, 139.767125); // 東京駅
  String _cityName = "";
  String _selectedSeason = "春"; // デフォルトの季節

  final List<String> seasons = ["春", "夏", "秋", "冬"];

  // マーカーの位置に基づいて都市名を取得
  Future<void> _getCityNameFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String cityName = place.locality ?? place.subLocality ?? "";

        if (cityName.endsWith('City')) {
          cityName = cityName.replaceAll(' City', '');
        }

        setState(() {
          _cityName = cityName;
        });
      } else {
        setState(() {
          _cityName = "都市名が見つかりません";
        });
      }
    } catch (e) {
      setState(() {
        _cityName = "エラー: 都市名を取得できませんでした";
      });
      print("逆ジオコーディングエラー: $e");
    }
  }

  List<Color> _getSeasonColors() {
    switch (_selectedSeason) {
      case "春":
        return [Colors.pink[200]!, Colors.pink[400]!, Colors.pink[600]!]; // 春の色
      case "夏":
        return [Colors.blue[200]!, Colors.blue[400]!, Colors.blue[600]!]; // 夏の色
      case "秋":
        return [Colors.orange[200]!, Colors.orange[400]!, Colors.orange[600]!]; // 秋の色
      case "冬":
        return [Colors.blueGrey[200]!, Colors.blueGrey[400]!, Colors.blueGrey[600]!]; // 冬の色
      default:
        return [Colors.grey[300]!, Colors.grey[500]!, Colors.grey[700]!]; // デフォルトの色
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    final Color backgroundColor;
    final Color buttonColor;
    final Color textColor = Colors.white;

    switch (_selectedSeason) {
      case "春":
        backgroundColor = const Color(0xFFE8F5E9); // Spring - Light Green
        buttonColor = const Color(0xFF4CAF50); // Green
        break;
      case "夏":
        backgroundColor = const Color(0xFFE0F7FA); // Summer - Light Blue
        buttonColor = const Color(0xFF00BCD4); // Cyan
        break;
      case "秋":
        backgroundColor = const Color(0xFFFFF3E0); // Autumn - Light Orange
        buttonColor = const Color(0xFFFF9800); // Orange
        break;
      case "冬":
        backgroundColor = const Color(0xFFECEFF1); // Winter - Light Grey
        buttonColor = const Color(0xFF607D8B); // Blue Grey
        break;
      default:
        backgroundColor = const Color(0xFFF5F5F5); // Default - Light Grey
        buttonColor = const Color(0xFF4A4A4A); // Default - Dark Grey
    }

    final title = Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      height: screenHeight * 0.1,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/huku_title.png',
            width: 70,
            height: 70,
          ),
          const SizedBox(width: 10),
          const Text(
            "着る服チョイス",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );

    final mapCon = Container(
      height: screenHeight * 0.45,
      width: double.infinity,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0), // 角を丸くする半径
            child: SizedBox(
              height: screenHeight * 0.25,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _currentPosition,
                  initialZoom: 10.0,
                  onTap: (tapPosition, point) async {
                    setState(() {
                      _currentPosition = point;
                    });
                    await _getCityNameFromCoordinates();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentPosition,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            value: _selectedSeason,
            items: seasons.map((String season) {
              return DropdownMenuItem<String>(
                value: season,
                child: Text(
                  season,
                  style: GoogleFonts.notoSansJp(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // アイテムのテキストカラー
                    ),
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSeason = newValue!;
              });
            },
            icon: const Icon(
              Icons.arrow_drop_down_circle, // おしゃれなアイコンを使用
              color: Colors.white, // アイコンの色
            ),
            dropdownColor: const Color.fromRGBO(0, 150, 136, 1), // ドロップダウンメニューの背景色
            style: const TextStyle(
              color: Colors.white, // ドロップダウンの選択時のテキストカラー
            ),
            underline: Container(
              height: 2,
              color: Colors.tealAccent, // ドロップダウンボタン下の線の色
            ),
            borderRadius: BorderRadius.circular(12), // 角丸
            selectedItemBuilder: (BuildContext context) {
              return seasons.map((String season) {
                return Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    season,
                    style: GoogleFonts.notoSansJp(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _getSeasonColors().last, // 季節に応じた色を反映
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_cityName.isNotEmpty && _cityName != "都市名が取得できません") {
                context.push('/choice', extra: {'city': _cityName, 'season': _selectedSeason});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('都市名が取得できませんでした')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(0), // コンテナの余白をゼロに設定
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // ボタンの角丸
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _getSeasonColors(), // 季節ごとの色を取得
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  "チョイス！",
                  style: GoogleFonts.notoSansJp(
                    textStyle: const TextStyle(
                      color: Colors.white, // ボタンのテキストカラー
                      fontSize: 24,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final registerCon = Container(
      height: screenHeight * 0.30,
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => context.push('/registerClothes'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 100),
          padding: const EdgeInsets.all(50), // コンテナの余白をゼロに設定
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // ボタンの角丸
          ),
          backgroundColor: Colors.transparent, // 背景を透明に設定
        ).copyWith(
          shadowColor: MaterialStateProperty.all(Colors.transparent), // 影を透明に設定
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getSeasonColors(), // 季節ごとの色を取得
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            alignment: Alignment.center,
            child: Text(
              "服登録",
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(
                  color: Colors.white, // ボタンのテキストカラー
                  fontSize: 24,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    final allObject = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [title, mapCon, registerCon],
    );

    final body = Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.red, width: 2)),
      ),
      child: allObject,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.071), // AppBarの高さ
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getSeasonColors(), // AppBarのグラデーションを季節に応じて変更
            ),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text(
                  '着る服チョイス',
                  style: GoogleFonts.playfairDisplay(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.history),
                    onPressed: () => context.push('/history'),
                    iconSize: 50,
                    color: Colors.white, // アイコンの色
                  ),
                ],
                backgroundColor: Colors.transparent, // 背景を透明にしてグラデーションを適用
                elevation: 0, // AppBarの影をなくす
              ),
              Container(
                height: 2, // 区切り線の高さ
                color: Colors.grey, // 区切り線の色
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: const Text(
                'メニュー',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('ホーム'),
              onTap: () {
                Navigator.pop(context);
                context.push('/'); // ホーム画面に戻る
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('履歴'),
              onTap: () {
                Navigator.pop(context);
                context.push('/history'); // 履歴画面に遷移
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('設定'),
              onTap: () {
                Navigator.pop(context);
                context.push('/settings'); // 設定画面に遷移
              },
            ),
            // 追加：服リスト画面への遷移
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('服リスト'),
              onTap: () {
                Navigator.pop(context);
                context.push('/clothesList'); // 服リスト画面に遷移
              },
            ),
            // ここに他のメニュー項目も追加可能
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: body,
    );
  }
}

