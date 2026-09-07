import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/utils/banner_ad_widget.dart';
// import 'package:kids/utils/admob.dart';
import 'package:kids/utils/model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class NumberVideo extends StatefulWidget {
  @override
  State<NumberVideo> createState() => _NumberVideoState();
}

List<Numbermodel> numbervideolist = numbervideo1();
List<String> numbervideoURLlist = numbervideoURL();

class _NumberVideoState extends State<NumberVideo> {
  Future<void> _launchYoutubeVideo(String url) async {
    await launch(url);
  }

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
                        text: 'Number Video',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
        child: GridView.builder(
          itemCount: numbervideolist.length,
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
              onTap: () => _launchYoutubeVideo(numbervideoURLlist[index]),
              gradientColors: gradients[index % gradients.length],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(numbervideolist[index].image!,
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          height: 100),
                      const SizedBox(height: 8),
                      AdventureText(
                        text: numbervideolist[index].Text!,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
              ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BannerAdWidget(),
    );
  }
}
