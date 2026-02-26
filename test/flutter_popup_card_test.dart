import 'package:flutter/material.dart';
import 'package:flutter_popup_card/flutter_popup_card.dart';
import 'package:flutter_test/flutter_test.dart';

const Key _popupChildKey = Key('popup-child');

void main() {
  testWidgets('Popup card shows child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PopupCard(
            child: SizedBox(
              key: _popupChildKey,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
    expect(find.byKey(_popupChildKey), findsOneWidget);
  });

  testWidgets('Popup card matches style', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 300);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: PopupCard(
              elevation: 0,
              color: Colors.yellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  key: _popupChildKey,
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final popupFinder = find.byType(PopupCard);
    await expectLater(popupFinder, matchesGoldenFile('popup.png'));
  });

  testWidgets('Popup card is shown and hidden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );
    expect(find.byType(PopupCard), findsNothing);

    final BuildContext context = tester.element(find.byType(Container));

    showPopupCard(
      context: context,
      builder: (context) {
        return PopupCard(
          elevation: 0,
          color: Colors.yellow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              key: _popupChildKey,
              width: 20,
              height: 20,
            ),
          ),
        );
      },
    );
    await tester.pumpAndSettle();
    expect(find.byType(PopupCard), findsOneWidget);
    expect(find.byKey(_popupChildKey), findsOneWidget);

    Navigator.of(context).pop();
    await tester.pumpAndSettle();
    expect(find.byType(PopupCard), findsNothing);
  });
}
