import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final LatLng _initialPosition = LatLng(35.681236, 139.767125); // 東京駅

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
                center: _initialPosition,
                zoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _initialPosition,
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.location_pin, color: Colors.white, size: 40),
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
              final city = _cityController.text;
              if (city.isNotEmpty) {
                context.push('/choice', extra: city);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('都市名を入力してください')),
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