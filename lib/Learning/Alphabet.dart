import 'package:flutter/material.dart';
import 'package:kids/Alphabetssound/Alphasound.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
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
      MaterialPageRoute<void>(builder: (BuildContext context) => AlphaSound(index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The logo footer is the first thing to go on short screens.
    final bool showFooter = MediaQuery.of(context).size.height >= 640;

    return Scaffold(
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
                    const SizedBox(width: 56),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
                  itemCount: kidslist.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _LetterTile(
                      letter: kidslist[index],
                      accent: KidsTheme.categoryPalette[
                          index % KidsTheme.categoryPalette.length],
                      // Stagger over six steps so neighbours never bob in sync.
                      bounceDelay:
                          Duration(milliseconds: (index % 6) * 180),
                      onTap: () => _openLetter(index),
                    );
                  },
                ),
              ),
              if (showFooter)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KidsBounce(
                    offset: 4,
                    scale: 0.02,
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 46,
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object error,
                              StackTrace? stack) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Candy card holding one big 3D letter.
class _LetterTile extends StatelessWidget {
  final Numbermodel letter;
  final Color accent;
  final Duration bounceDelay;
  final VoidCallback onTap;

  const _LetterTile({
    Key? key,
    required this.letter,
    required this.accent,
    required this.bounceDelay,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(KidsTheme.radiusTile);

    final Widget card = Container(
      decoration: BoxDecoration(
        gradient: KidsTheme.softFill(accent, strength: 0.26),
        borderRadius: radius,
        border: Border.all(color: accent, width: 5),
        boxShadow: KidsTheme.pillowShadow(accent, depth: 5),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: KidsTheme.glossSheen,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Image.asset(
                letter.image!,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
                errorBuilder:
                    (BuildContext context, Object error, StackTrace? stack) {
                  return KidsBubbleTitle(
                    letter.Text ?? '',
                    fontSize: 64,
                    outlineColor: KidsTheme.darken(accent, 0.3),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );

    return KidsSquish(
      onTap: onTap,
      pressedScale: 0.93,
      child: KidsBounce(
        delay: bounceDelay,
        offset: 5,
        scale: 0.012,
        child: card,
      ),
    );
  }
}
