import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:kids/utils/admob.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class AlphaSound extends StatefulWidget {
  int index1;

  AlphaSound(this.index1);
  @override
  State<AlphaSound> createState() => _AlphaSoundState();
}

List<Numbermodel> kidslist = KidsList1();

class _AlphaSoundState extends State<AlphaSound> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    Future _speak() async {
      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(10.0);
      await flutterTts.setVolume(10.0);
      print(await flutterTts.getVoices);
      int count = widget.index1;

      await flutterTts.speak(kidslist[count].Text!);
    }

    final _controller = new PageController();
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
                        text: 'Alphabet',
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
        height: MediaQuery.of(context).size.height * 600,
        width: MediaQuery.of(context).size.height * 1000,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage("assets/images/Union 12.png")),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AdventureCard(
                      gradientColors: const [
                        Color(0xFFB8E6F5),
                        Color(0xFFFFE5A8),
                      ],
                      child: PageView.builder(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: kidslist.length,
                      itemBuilder: (BuildContext context, int index1) {
                        return Center(
                          child: Image.asset(
                            kidslist[widget.index1].image!,
                            alignment: Alignment.topCenter,
                          ),
                        );
                      },
                    ),
                    ),
                  ),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () => _speak(),
                          child: Image.asset(
                            'assets/images/11MaskGroup3.png',
                            alignment: Alignment.topCenter,
                          )),
                      Align(
                        heightFactor: 0.5,
                        child: Center(
                          child: ListTile(
                            trailing: InkWell(
                              onTap: () {
                                if (widget.index1 >= 0 && widget.index1 < 25) {
                                  print(widget.index1);
                                  setState(() {
                                    widget.index1++;
                                  });
                                }
                                _speak();
                              },
                              child: Image(
                                image: AssetImage(
                                    'assets/images/11MaskGroup5.png'),
                              ),
                            ),
                            leading: InkWell(
                              onTap: () {
                                if (widget.index1 > 0 && widget.index1 <= 25) {
                                  setState(() {
                                    widget.index1--;
                                  });
                                }
                                _speak();
                              },
                              child: Image(
                                image: AssetImage(
                                    'assets/images/11MaskGroup4.png'),
                              ),
                            ),
                          ),
                        ),
                      )
                    ])
              ]))),
        ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Container(
      //     height: MediaQuery.of(context).size.width *0.13,
      //     width: 25,
      //     child: AdWidget(
      //       // ad:AdmobHelper.getBannerAd()..load(),
      //     ),
      //   ),
      // ),
    );
  }
}
