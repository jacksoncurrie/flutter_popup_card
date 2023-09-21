import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Popup card shows child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PopupCard(child: Text('M')),
        ),
      ),
    );
    expect(find.text('M'), findsOneWidget);
  });

  testWidgets('Popup card matches style', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PopupCard(
              elevation: 8,
              color: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('M'),
              ),
            ),
          ),
        ),
      ),
    );
    final appFinder = find.byType(MaterialApp);
    await expectLater(appFinder, matchesGoldenFile('popup.png'));
  });

  testWidgets('Popup card is shown and hidden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );
    expect(find.text('M'), findsNothing);

    final BuildContext context = tester.element(find.byType(Container));

    showPopupCard(
      context: context,
      builder: (context) {
        return PopupCard(
          elevation: 8,
          color: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('M'),
          ),
        );
      },
    );
    await tester.pumpAndSettle();
    expect(find.text('M'), findsOneWidget);
    final appFinder = find.byType(MaterialApp);
    await expectLater(appFinder, matchesGoldenFile('popup.png'));

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(find.text('M'), findsNothing);
  });
}
