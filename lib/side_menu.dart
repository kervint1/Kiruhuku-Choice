import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final header = DrawerHeader(
      child: Text('header'),
    );

    final tileA = ListTile(
      title: Text('title'),
      onTap: () {
        debugPrint('titleAをタップしました。');
      },
    );
    final tileB = ListTile(
        title: Text('title'),
        onTap: () {
          debugPrint('titleBをタップしました。');
        });
    final tileC = ListTile(
        title: Text('title'),
        onTap: () {
          debugPrint('titleCをタップしました。');
        });
  }
}
