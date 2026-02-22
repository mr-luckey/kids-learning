import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/model.dart';
import 'package:kids/widgets/adventure_background.dart';
import 'package:kids/widgets/adventure_card.dart';

class NumberSound extends StatefulWidget {
  int index1;
  NumberSound(this.index1);
  @override
  State<NumberSound> createState() => _NumberSoundState();
}

class _NumberSoundState extends State<NumberSound> {
  final FlutterTts flutterTts = FlutterTts();
  List<Numbermodel> list = NumberList();
  @override
  Widget build(BuildContext context) {
    Future _speak() async {
      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(10.0);
      print(await flutterTts.getVoices);
      int count = widget.index1;
      await flutterTts.speak(list[count].Text!);
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
                          text: 'Number',
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
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/images/Union 12.png")),
          ),
          child: Center(
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index1) {
                      return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              list[widget.index1].image!,
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                            Image.asset(
                              list[widget.index1].image2!,
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.width * 0.3,
                            ),
                          ]);
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
                            if (widget.index1 >= 0 && widget.index1 < 99) {
                              print(widget.index1);
                              setState(() {
                                widget.index1++;
                              });
                            }
                            _speak();
                          },
                          child: Image(
                            image: AssetImage('assets/images/11MaskGroup5.png'),
                          ),
                        ),
                        leading: InkWell(
                          onTap: () {
                            if (widget.index1 > 0 && widget.index1 <= 99) {
                              setState(() {
                                widget.index1--;
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
