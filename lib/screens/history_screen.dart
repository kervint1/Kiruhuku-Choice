import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //サンプ履歴データ
    final List<String> historyData = [
      '2024-08-23: 制服',
      '2024-08-22: 青のシャツを選択',
      '2024-08-21: 赤のスカートを選択',
      '2024-08-20: 白のTシャツを選択',
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("履歴"),
      ),
      body: ListView.builder(
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              historyData[index],
              style: GoogleFonts.notoSansJp(
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            leading: const Icon(Icons.history),
            onTap: () {
              // 履歴項目がタップされたときの処理（必要に応じて追加）
            },
          );
        },
      ),
    );
  }
}
