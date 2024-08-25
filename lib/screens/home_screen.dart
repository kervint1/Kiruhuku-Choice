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
          Text(
            "着る服チョイス",
            style: GoogleFonts.notoSerif(
              textStyle: TextStyle(
                color: buttonColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
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
            borderRadius: BorderRadius.circular(20.0),
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
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentPosition,
                        child: Icon(
                          Icons.location_pin,
                          color: buttonColor,
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
                  style: GoogleFonts.notoSans(
                    textStyle: TextStyle(
                      color: buttonColor,
                      fontSize: 18,
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
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_cityName.isNotEmpty && _cityName != "都市名が取得できません") {
                context.push('/choice',
                    extra: {'city': _cityName, 'season': _selectedSeason});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('都市名が取得できませんでした')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              backgroundColor: buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              "チョイス！",
              style: GoogleFonts.notoSansJp(
                textStyle: TextStyle(
                  color: textColor,
                  fontSize: 24,
                ),
              ),
              textAlign: TextAlign.center,
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
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "服登録ボタン",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
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
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      child: allObject,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: Column(
          children: [
            AppBar(
              title: Text(
                '着る服チョイス',
                style: GoogleFonts.sawarabiMincho(
                  textStyle: const TextStyle(
                    fontSize: 30,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history, color: Color(0xFF4A4A4A)),
                  onPressed: () => context.push('/history'),
                  iconSize: 50,
                ),
              ],
              backgroundColor: Colors.black26,
              elevation: 0,
            ),
            Container(
              height: 2,
              color: Colors.grey,
            ),
          ],
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: body,
    );
  }
}
