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
                        child: const Icon(
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
                child: Text(season),
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
                context.push('/choice', extra: {'city': _cityName, 'season': _selectedSeason});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('都市名が取得できませんでした')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              "チョイス！",
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 70, 70, 70),
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
          disabledForegroundColor: Colors.blue,
          foregroundColor: const Color.fromARGB(255, 70, 70, 70),
        ),
        child: const Text("服登録ボタン"),
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
        preferredSize: Size.fromHeight(screenHeight * 0.1), // AppBarの高さ
        child: Column(
          children: [
            AppBar(
              title: Text(
                '着る服チョイス',
                style: GoogleFonts.playfairDisplay(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () => context.push('/history'),
                  iconSize: 50,
                ),
              ],
              backgroundColor: Colors.white, // AppBarの背景色
              elevation: 0, // AppBarの影をなくす
            ),
            Container(
              height: 2, // 区切り線の高さ
              color: Colors.grey, // 区切り線の色
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
