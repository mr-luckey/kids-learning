import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/BridSound.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class Brids extends StatefulWidget {
  @override
  State<Brids> createState() => _BridsState();
}

List<Numbermodel> bridslist = BRIDS1();

class _BridsState extends State<Brids> {
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
                        color: const Color(0xFF1A5F7A),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: AdventureTitle(
                          text: 'Bird',
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
              itemCount: bridslist.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                final gradients = [
                  [Color(0xFFB8E6F5), Color(0xFFFFE5A8)],
                  [Color(0xFFFFB5D0), Color(0xFFFFE5A8)],
                  [Color(0xFFA8E6A0), Color(0xFFB8D4F0)],
                ];
                return AdventureCard(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BridSound(index),
                          ));
                    },
                    gradientColors: gradients[index % gradients.length],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              bridslist[index].image!,
                              height: 100,
                            ),
                            const SizedBox(height: 8),
                            AdventureText(
                              text: bridslist[index].Text!,
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
