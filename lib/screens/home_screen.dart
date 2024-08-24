import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

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
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: '都市名を入力してください',
              border: OutlineInputBorder(),
            ),
            style: GoogleFonts.notoSansJp(
              textStyle: const TextStyle(fontSize: 24),
            ),
            textAlign: TextAlign.center,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/huku_touroku-logo.png', // ロゴのパス
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 8), // ロゴとテキストの間にスペースを追加
            const Text("服登録ボタン"),
          ],
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
