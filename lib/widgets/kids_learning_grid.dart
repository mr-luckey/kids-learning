import 'package:flutter/material.dart';
import 'package:kids/utils/banner_ad_widget.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_3d_letter.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Shared 2-column engaging candy grid for Learning category screens.
class KidsLearningGrid extends StatelessWidget {
  final String title;
  final List<Numbermodel> items;
  final void Function(BuildContext context, int index) onItemTap;

  const KidsLearningGrid({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BannerAdWidget(placement: 'learning'),
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: <Widget>[
                    KidsCircleNav.back(
                      onTap: () {
                        KidsSound.instance.whoosh();
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: KidsBubbleTitle(title, fontSize: 34),
                    ),
                    const SizedBox(width: 56),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 18),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Color border = KidsTheme
                        .categoryPalette[index % KidsTheme.categoryPalette.length];
                    final Numbermodel item = items[index];
                    final String label = item.Text ?? '';
                    return KidsEngagingCard(
                      label: label.isEmpty ? title : label,
                      color: border,
                      imageAsset: item.image,
                      imageAsset2: item.image2,
                      letter: Kids3DLetter.isLetter(label) ? label : null,
                      bounceDelay:
                          Duration(milliseconds: (index % 6) * 160),
                      onTap: () {
                        KidsSound.instance.whoosh();
                        onItemTap(context, index);
                      },
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
