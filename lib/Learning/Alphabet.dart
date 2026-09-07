import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/Alphasound.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_3d_letter.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

class Alphabet extends StatefulWidget {
  const Alphabet({Key? key}) : super(key: key);

  @override
  State<Alphabet> createState() => _AlphabetState();
}

List<Numbermodel> kidslist = KidsList1();

class _AlphabetState extends State<Alphabet> {
  void _openLetter(int index) {
    KidsSound.instance.whoosh();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => AlphaSound(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(),
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                child: Row(
                  children: <Widget>[
                    KidsCircleNav.back(
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const Expanded(
                      child: Center(
                        child: KidsBubbleTitle('Alphabet', fontSize: 36),
                      ),
                    ),
                    Kids3DLetter(letter: 'A', size: 48, animate: true),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 20),
                  itemCount: kidslist.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Numbermodel letter = kidslist[index];
                    final Color accent = KidsTheme.categoryPalette[
                        index % KidsTheme.categoryPalette.length];
                    return KidsEngagingCard(
                      label: letter.Text ?? '',
                      color: accent,
                      letter: letter.Text,
                      bounceDelay:
                          Duration(milliseconds: (index % 6) * 160),
                      onTap: () => _openLetter(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
