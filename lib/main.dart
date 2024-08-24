import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiruhuku_choice/routes/app_routes.dart';
import 'package:kiruhuku_choice/side_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  //ドロワー
  final drawer = Drawer(
    child: SideMenu(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '着る服チョイス',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.notoSansJp(),
        ),
      ),
      routerConfig: router,
    );
  }
}
