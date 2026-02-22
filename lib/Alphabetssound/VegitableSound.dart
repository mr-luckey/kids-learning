import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class VegitableSound extends StatefulWidget {
  int index;

  VegitableSound(this.index);
  @override
  State<VegitableSound> createState() => _VegitableSoundState();
}

List<Numbermodel> vegitablelist = vegitable1();

class _VegitableSoundState extends State<VegitableSound> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    int i = 0;
    Future _speak() async {
      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(10.0);
      print(await flutterTts.getVoices);
      int count = widget.index;
      await flutterTts.speak(vegitablelist[count].Text!);
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
                          text: 'Vegetable',
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
          height: 650,
          width: 500,
          decoration: BoxDecoration(
            // color: LetsStartLearningbgcolor,
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/images/Union 12.png")),
          ),
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
                      itemCount: vegitablelist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Image.asset(
                            vegitablelist[widget.index].image!,
                            alignment: Alignment.topCenter,
                          ),
                        );
                      },
                    ),
                    ),
                  ),
                ),
                Column(children: [
                  InkWell(
                      onTap: () => _speak(),
                      child: Image.asset('assets/images/11MaskGroup3.png')),
                  Align(
                    heightFactor: 0.5,
                    child: Center(
                      child: ListTile(
                        trailing: InkWell(
                          onTap: () {
                            if (widget.index >= 0 && widget.index < 12) {
                              i++;
                              print(widget.index);
                              setState(() {
                                widget.index++;
                              });
                            }
                            _speak();
                            // changeImage(count);
                          },
                          child: Image(
                            image: AssetImage('assets/images/11MaskGroup5.png'),
                          ),
                        ),
                        leading: InkWell(
                          onTap: () {
                            if (widget.index > 0 && widget.index <= 12) {
                              i--;
                              setState(() {
                                widget.index--;
                              });
                            }
                            _speak();
                          },
                          child: Image(
                            image: AssetImage('assets/images/11MaskGroup4.png'),
                          ),
                        ),
                      ),
                    ),
                  )
                ])
              ]))),
                ),
              ],
            ),
          ),
        ));
  }
}
