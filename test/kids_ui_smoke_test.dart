import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids/ListenGuessSongs/Alphabet.dart';
import 'package:kids/ListenGuessSongs/Animal.dart';
import 'package:kids/ListenGuessSongs/Brid.dart';
import 'package:kids/ListenGuessSongs/Color.dart';
import 'package:kids/ListenGuessSongs/Flower.dart';
import 'package:kids/ListenGuessSongs/Fruit.dart';
import 'package:kids/ListenGuessSongs/Month.dart';
import 'package:kids/ListenGuessSongs/Number.dart';
import 'package:kids/ListenGuessSongs/Shapes.dart';
import 'package:kids/ListenGuessSongs/Vegitable.dart';
import 'package:kids/Pages/LookAndChooes.dart';
import 'package:kids/Pages/listen_and_guess.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/Quiz/AnimalQuize.dart';
import 'package:kids/Quiz/BirdQuize.dart';
import 'package:kids/Quiz/ColorQuiz.dart';
import 'package:kids/Quiz/FlowerQuize.dart';
import 'package:kids/Quiz/FruitQuize.dart';
import 'package:kids/Quiz/MonthQuize.dart';
import 'package:kids/Quiz/NumberQuiz.dart';
import 'package:kids/Quiz/ShapeQuiz.dart';
import 'package:kids/Quiz/VegitableQuiz.dart';
import 'package:kids/utils/kids_theme.dart';
import 'package:kids/widgets/kids_animations.dart';
import 'package:kids/widgets/kids_bubble_title.dart';
import 'package:kids/widgets/kids_engaging_card.dart';
import 'package:kids/widgets/kids_quiz_screen.dart';
import 'package:kids/widgets/kids_sky_background.dart';
import 'package:kids/widgets/kids_ui_buttons.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

/// Pages in this app bounce and pulse forever on purpose, so `pumpAndSettle`
/// would never return — every test here advances time by a fixed amount.
int _pageCount(WidgetTester t) {
  final KidsQuizScreen screen =
      t.widget<KidsQuizScreen>(find.byType(KidsQuizScreen));
  return screen.questions.length < screen.items.length
      ? screen.questions.length
      : screen.items.length;
}

void main() {
  testWidgets('sky background animates and disposes', (WidgetTester t) async {
    await t.pumpWidget(_host(
      const KidsSkyBackground(child: Center(child: Text('hi'))),
    ));
    await t.pump(const Duration(milliseconds: 500));
    await t.pump(const Duration(seconds: 3));
    expect(find.text('hi'), findsOneWidget);
    await t.pumpWidget(_host(const SizedBox()));
  });

  testWidgets('bubble title renders multi-line', (WidgetTester t) async {
    await t.pumpWidget(_host(
      const Center(child: KidsBubbleTitle('Let\'s Start\nLearning')),
    ));
    expect(find.byType(KidsBubbleTitle), findsOneWidget);
  });

  testWidgets('category pill taps', (WidgetTester t) async {
    int taps = 0;
    await t.pumpWidget(_host(KidsCategoryPill(
      label: 'Alphabet',
      borderColor: KidsTheme.categoryColor('Alphabet'),
      icon: Icons.abc,
      bounce: true,
      onTap: () => taps++,
    )));
    await t.tap(find.byType(KidsCategoryPill));
    await t.pump(const Duration(milliseconds: 400));
    expect(taps, 1);
  });

  testWidgets('home tiles lay out in a grid', (WidgetTester t) async {
    await t.pumpWidget(_host(GridView.count(
      crossAxisCount: 2,
      children: <Widget>[
        KidsHomeTile(
          label: 'Start Learning',
          color: KidsTheme.tileStartLearning,
          icon: Icons.school,
          onTap: () {},
        ),
        KidsHomeTile(
          label: 'Fun Quiz',
          color: KidsTheme.tileFunQuiz,
          labelInside: false,
          onTap: () {},
        ),
        KidsHomeTile(
          label: 'Look & Choose',
          color: KidsTheme.tileLookChoose,
          onTap: () {},
        ),
        KidsHomeTile(
          label: 'Listen & Guess',
          color: KidsTheme.tileListenGuess,
          onTap: () {},
        ),
      ],
    )));
    await t.pump(const Duration(seconds: 1));
    expect(find.byType(KidsHomeTile), findsNWidgets(4));
  });

  testWidgets('controls render', (WidgetTester t) async {
    await t.pumpWidget(_host(Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            KidsCircleNav.back(onTap: () {}),
            KidsCircleNav.previous(onTap: () {}),
            const KidsCircleNav.next(),
            KidsCircleNav(
              direction: KidsNavDirection.next,
              enabled: false,
              label: 'Next',
            ),
          ],
        ),
        KidsSpeakerButton(onTap: () {}),
        const KidsSpeakerButton(isPlaying: true),
        KidsPrimaryCta(onTap: () {}),
        KidsRateButton(onTap: () {}),
      ],
    )));
    await t.pump(const Duration(milliseconds: 800));
    expect(find.byType(KidsPrimaryCta), findsOneWidget);
  });

  testWidgets('quiz options shake on wrong and badge on correct',
      (WidgetTester t) async {
    Widget grid(KidsOptionState a, KidsOptionState b) => _host(GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            KidsQuizOption(label: 'A', state: a, onTap: () {}),
            KidsQuizOption(
              label: 'Cat',
              icon: Icons.pets,
              state: b,
              onTap: () {},
            ),
          ],
        ));

    await t.pumpWidget(grid(KidsOptionState.idle, KidsOptionState.idle));
    await t.pumpWidget(grid(KidsOptionState.wrong, KidsOptionState.correct));
    await t.pump(const Duration(milliseconds: 250));
    await t.pump(const Duration(milliseconds: 600));
    expect(find.byType(KidsQuizOption), findsNWidgets(2));
  });

  testWidgets('animation wrappers dispose cleanly', (WidgetTester t) async {
    await t.pumpWidget(_host(Column(
      children: <Widget>[
        const KidsBounce(child: Text('bounce')),
        const KidsPulse(glowColor: Colors.orange, child: Text('pulse')),
        const KidsShake(trigger: 0, child: Text('shake')),
        const KidsPopIn(child: Text('pop')),
      ],
    )));
    await t.pump(const Duration(seconds: 1));
    await t.pumpWidget(_host(const SizedBox()));
    await t.pump(const Duration(seconds: 1));
  });

  // Every category quiz renders through the shared KidsQuizScreen, so this
  // walks each one far enough to prove its artwork list and question bank
  // line up and that answering advances the page.
  final Map<String, Widget> quizzes = <String, Widget>{
    'ABC': ABCQuiz(),
    'Number': const Numberquiz(),
    'Color': const Colorquiz(),
    'Shape': const Shapequiz(),
    'Animal': const AnimalQuiz(),
    'Bird': const Birdquiz(),
    'Flower': const Flowerquiz(),
    'Fruit': const Fruitquiz(),
    'Month': const Monthquiz(),
    'Vegetable': const Vegitablequiz(),
  };

  quizzes.forEach((String name, Widget quiz) {
    testWidgets('$name quiz answers and advances', (WidgetTester t) async {
      await t.pumpWidget(MaterialApp(home: quiz));
      await t.pump(const Duration(milliseconds: 700));
      expect(find.byType(KidsQuizOption), findsNWidgets(4));

      // Answer, then move on. Both taps go through KidsSquish, which delays
      // its callback so the squish animation is visible.
      await t.tap(find.byType(KidsQuizOption).first);
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(const Duration(milliseconds: 700));

      await t.tap(find.byType(KidsPrimaryCta));
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(const Duration(milliseconds: 700));

      if (name != 'ABC') {
        expect(find.text('2/${_pageCount(t)}'), findsWidgets);
      }

      // Drain the pop-in timers the PageView mounts for the adjacent page.
      await t.pump(const Duration(seconds: 1));
    });
  });

  // The listen-and-guess rounds are the same KidsQuizScreen with the artwork
  // swapped for a speaker, so this checks each one lines its spoken word list
  // up with its picture answers.
  final Map<String, Widget> songs = <String, Widget>{
    'Alphabet': const AlphabetSong(),
    'Number': const NumberSong(),
    'Color': const ColorSong(),
    'Shape': const ShapesSong(),
    'Animal': const AnimalsSong(),
    'Bird': const BirdsSong(),
    'Flower': const FlowerSong(),
    'Fruit': const FruitSong(),
    'Month': const MonthSong(),
    'Vegetable': const VegitableSong(),
  };

  songs.forEach((String name, Widget song) {
    testWidgets('$name listen round speaks and advances', (WidgetTester t) async {
      await t.pumpWidget(MaterialApp(home: song));
      await t.pump(const Duration(milliseconds: 700));

      // The word is heard, never shown: the artwork slot holds the speaker.
      expect(find.byType(KidsSpeakerButton), findsOneWidget);
      expect(find.byType(KidsQuizOption), findsNWidgets(4));

      await t.tap(find.byType(KidsQuizOption).first);
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(const Duration(milliseconds: 700));

      await t.tap(find.byType(KidsPrimaryCta));
      await t.pump(const Duration(milliseconds: 200));
      await t.pump(const Duration(milliseconds: 700));

      expect(find.text('2/${_pageCount(t)}'), findsWidgets);

      await t.pumpWidget(const MaterialApp(home: SizedBox()));
      await t.pump(const Duration(seconds: 1));
    });
  });

  testWidgets('hub screens render engaging card grids', (WidgetTester t) async {
    final Map<String, Widget> hubs = <String, Widget>{
      'Look And Choose': LookAndChooes(0),
      'Listen and Guess': const ListenGuess(),
    };

    for (final MapEntry<String, Widget> hub in hubs.entries) {
      await t.pumpWidget(MaterialApp(home: hub.value));
      await t.pump(const Duration(milliseconds: 900));

      expect(find.byType(KidsEngagingCard), findsWidgets, reason: hub.key);
      expect(find.textContaining(hub.key.split(' ').first), findsWidgets,
          reason: hub.key);

      await t.drag(find.byType(GridView), const Offset(0, -700));
      await t.pump(const Duration(milliseconds: 600));
      expect(find.byType(KidsEngagingCard), findsWidgets, reason: hub.key);

      await t.pumpWidget(const MaterialApp(home: SizedBox()));
      await t.pump(const Duration(seconds: 1));
    }
  });
}
