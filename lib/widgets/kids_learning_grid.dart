import 'package:flutter/material.dart';
import 'package:kids/utils/kids_sound.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

/// Shared 2-column candy grid used by every Learning category screen.
class KidsLearningGrid extends StatelessWidget {
  final String title;
  final List<Numbermodel> items;
  final void Function(BuildContext context, int index) onItemTap;
  final String? footerAsset;

  const KidsLearningGrid({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemTap,
    this.footerAsset = 'assets/images/logo.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: KidsSkyBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Color border =
                        KidsTheme.categoryPalette[index % KidsTheme.categoryPalette.length];
                    final Numbermodel item = items[index];
                    return KidsBounce(
                      delay: Duration(milliseconds: (index % 6) * 180),
                      child: KidsSquish(
                        onTap: () {
                          KidsSound.instance.whoosh();
                          onItemTap(context, index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: KidsTheme.softFill(border),
                            borderRadius:
                                BorderRadius.circular(KidsTheme.radiusTile),
                            border: Border.all(color: border, width: 5),
                            boxShadow: KidsTheme.pillowShadow(border, depth: 5),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: IgnorePointer(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          KidsTheme.radiusTile),
                                      gradient: KidsTheme.glossSheen,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    item.image!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) =>
                                        KidsBubbleTitle(
                                      item.Text ?? '?',
                                      fontSize: 48,
                                      fillColor: border,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (footerAsset != null && screenH >= 640)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: KidsBounce(
                    child: Image.asset(footerAsset!, height: 56),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
