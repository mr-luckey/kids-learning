import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/ColorSound.dart';
import 'package:kids/utils/model.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class Color extends StatefulWidget {
  // int index;
  Color({Key? key}) : super(key: key);
  @override
  State<Color> createState() => _ColorState();
}

final FlutterTts flutterTts = FlutterTts();

class _ColorState extends State<Color> {
  List<Numbermodel> colorlist = COLOR1();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AdventureBackground(
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: const ui.Color(0xFF1A5F7A),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: AdventureTitle(
                          text: 'Color',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            child: GridView.builder(
              itemCount: colorlist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                final gradients = [
                  [ui.Color(0xFFB8E6F5), ui.Color(0xFFFFE5A8)],
                  [ui.Color(0xFFFFB5D0), ui.Color(0xFFFFE5A8)],
                  [ui.Color(0xFFA8E6A0), ui.Color(0xFFB8D4F0)],
                ];
                return AdventureCard(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ColorSound(index),
                          ));
                    },
                    gradientColors: gradients[index % gradients.length],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              colorlist[index].image!,
                              height: 100,
                            ),
                            const SizedBox(height: 8),
                            AdventureText(
                              text: colorlist[index].Text!,
                              fontSize: 14,
                            ),
                          ]),
                    ));
              },
            ),
          ),
        ),
                ),
              ],
            ),
          ),
        ));
  }
}
