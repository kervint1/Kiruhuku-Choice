import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiruhuku_choice/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '着る服チョイス',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.notoSansJp(),
        ),
      ),
      routerConfig: router,
    );
  }
}
