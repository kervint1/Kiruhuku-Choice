import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // サンプル履歴データ
    final List<Map<String, String>> historyData = [
      {
        'date': '2024-08-23',
        'description': '制服',
        'image': 'assets/images/uniform.png'
      },
      {
        'date': '2024-08-23',
        'description': '制服',
        'image': 'assets/images/uniform.png'
      },
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 画面の幅に応じて列数を変える
          int crossAxisCount;
          double childAspectRatio;

          if (constraints.maxWidth > 1200) {
            // 大きい画面 (パソコン)
            crossAxisCount = 4;
            childAspectRatio = 1.0;
          } else if (constraints.maxWidth > 800) {
            // 中くらいの画面 (タブレット)
            crossAxisCount = 3;
            childAspectRatio = 0.9;
          } else {
            // 小さい画面 (スマホ)
            crossAxisCount = 2;
            childAspectRatio = 0.7;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: childAspectRatio,
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
          );
        },
      ),
    );
  }
}
