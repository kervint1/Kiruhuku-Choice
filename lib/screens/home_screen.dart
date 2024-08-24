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
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              hintText: '都市名を入力してください',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 150, 150, 150),
                fontSize: 24,
              ),
              border: OutlineInputBorder(),
            ),
            style: GoogleFonts.notoSansJp(
              textStyle: const TextStyle(fontSize: 24),
              color: Colors.black,
            ),
            textAlign: TextAlign.center, // TextField内にtextAlignを追加
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
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text(
              "表示",
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 70, 70, 70),
                  fontSize: 24,
                ),
              ),
              textAlign: TextAlign.center, // Textウィジェット内にtextAlignを適用
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/huku_touroku-logo.png', // ロゴのパス
              width: 70,
              height: 70,
            ),
            const SizedBox(width: 8), // ロゴとテキストの間にスペースを追加

            Text(
              "服を登録する",
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/history');
                  },
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

//ボタン文字の色 ARGB(255, 70, 70, 70)
