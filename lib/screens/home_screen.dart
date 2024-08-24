import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //全体の割合0.94まで
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

<<<<<<< HEAD
    final mapCon = Container(
=======
    final history = InkWell(
      onTap: () {
        context.go('/history');
      },
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
        height: screenHeight * 0.15,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(
          "履歴",
          style: GoogleFonts.notoSansJp(
              textStyle: const TextStyle(color: Colors.black, fontSize: 24)),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final map_con = Container(
>>>>>>> f6c16938b8a8d6b91f88ff5b2bd80fca27283359
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      height: screenHeight * 0.39,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Map",
        style: GoogleFonts.notoSansJp(
            textStyle: const TextStyle(color: Colors.black, fontSize: 24)),
        textAlign: TextAlign.center,
      ),
    );

    final registerCon = Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
      height: screenHeight * 0.3,
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Registerbotton",
        style: GoogleFonts.notoSansJp(
            textStyle: const TextStyle(color: Colors.black, fontSize: 24)),
        textAlign: TextAlign.center,
      ),
    );

    final allObject = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
<<<<<<< HEAD
        children: [title, mapCon, registerCon]);
=======
        children: [title, history, map_con, register_con]);
>>>>>>> f6c16938b8a8d6b91f88ff5b2bd80fca27283359

    final body = Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.red, width: 2))),
      child: allObject,
    );

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.1,
          title: const Text('着る服チョイス'),
        ),
        backgroundColor: Colors.white,
        body: body);
  }
}
