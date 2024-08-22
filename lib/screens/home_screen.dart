import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('着る服チョイス')),
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "着る服チョイス",
          style: GoogleFonts.notoSansJp(
              textStyle: const TextStyle(color: Colors.black, fontSize: 24)),
        ),
      ),
    );
  }
}
