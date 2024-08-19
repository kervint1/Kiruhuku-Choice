import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "着る服チョイス",
          style: GoogleFonts.notoSansJp(
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    ),
  ));
}
