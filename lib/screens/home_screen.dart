import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart'; // 逆ジオコーディング用

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng _currentPosition = LatLng(35.681236, 139.767125); // 東京駅
  String _cityName = "";

  // マーカーの位置に基づいて都市名を取得
Future<void> _getCityNameFromCoordinates() async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // 区名を取得し、必要な部分を抽出
      String cityName = place.locality ?? place.subLocality ?? "";

      // 'City'を削除する処理
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
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      height: screenHeight * 0.15,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "着る服チョイス",
        style: GoogleFonts.notoSansJp(
            textStyle: const TextStyle(color: Colors.black, fontSize: 24)),
        textAlign: TextAlign.center,
      ),
    );

    final mapCon = Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      height: screenHeight * 0.39,
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.3,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _currentPosition,
                initialZoom: 10.0,
                onTap: (tapPosition, point) async {
                  setState(() {
                    _currentPosition = point;
                  });
                  // 都市名を更新
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_cityName.isNotEmpty && _cityName != "都市名が取得できません") {
                context.push('/choice', extra: _cityName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('都市名が取得できませんでした')),
                );
              }
            },
            child: Text(
              "表示",
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(color: Colors.black, fontSize: 24),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    final registerCon = Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      height: screenHeight * 0.3,
      width: double.infinity,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => context.push('/registerClothes'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 250),
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
          border: Border(bottom: BorderSide(color: Colors.red, width: 2))),
      child: allObject,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.1,
        title: const Text('着る服チョイス'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.push('/history');
            },
            iconSize: 50,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
