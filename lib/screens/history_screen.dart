import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Image.asset()写真

    //サンプ履歴データ
    final List<Map<String, String>> historyData = [
      {
        'date': '2024-08-23',
        'description': '制服',
        'image': 'assets/images/uniform.png'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("履歴"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2列
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7, // 縦横比
        ),
        itemCount: historyData.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    historyData[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                // 日付と説明を表示
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${historyData[index]['date']}: ${historyData[index]['description']}',
                    style: GoogleFonts.notoSansJp(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // 詳細ボタンを追加
                ElevatedButton(
                  onPressed: () {
                    // 詳細ページへの遷移などの処理をここに記述
                  },
                  child: const Text('詳細'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
