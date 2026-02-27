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

  testWidgets('Popup card can anchor to key context', (tester) async {
    final triggerKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: Builder(
              builder: (context) {
                return SizedBox(
                  key: triggerKey,
                  width: 40,
                  height: 20,
                );
              },
            ),
          ),
        ),
      ),
    );

    showPopupCard(
      context: tester.element(find.byType(Scaffold)),
      anchorKey: triggerKey,
      alignment: Alignment.bottomLeft,
      builder: (context) {
        return const PopupCard(
          child: SizedBox(
            key: _popupChildKey,
            width: 20,
            height: 20,
          ),
        );
      },
    );

    await tester.pumpAndSettle();

    final triggerBottomLeft = tester.getBottomLeft(find.byKey(triggerKey));
    final popupTopLeft = tester.getTopLeft(find.byKey(_popupChildKey));

    expect(popupTopLeft.dx, closeTo(triggerBottomLeft.dx, 0.1));
    expect(popupTopLeft.dy, closeTo(triggerBottomLeft.dy, 0.1));
  });

  testWidgets('Popup card can align to right side of anchor key',
      (tester) async {
    final triggerKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                key: triggerKey,
                width: 40,
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );

    showPopupCard(
      context: tester.element(find.byType(Scaffold)),
      anchorKey: triggerKey,
      alignment: Alignment.bottomRight,
      builder: (context) {
        return const PopupCard(
          child: SizedBox(
            key: _popupChildKey,
            width: 20,
            height: 20,
          ),
        );
      },
    );

    await tester.pumpAndSettle();

    final triggerBottomRight = tester.getBottomRight(find.byKey(triggerKey));
    final popupTopRight = tester.getTopRight(find.byKey(_popupChildKey));

    expect(popupTopRight.dx, closeTo(triggerBottomRight.dx, 0.1));
    expect(popupTopRight.dy, closeTo(triggerBottomRight.dy, 0.1));
  });

  testWidgets('Popup card supports top alignment from anchor key',
      (tester) async {
    final triggerKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                key: triggerKey,
                width: 40,
                height: 20,
              ),
            ),
          ),
        ),
      ),
    );

    showPopupCard(
      context: tester.element(find.byType(Scaffold)),
      anchorKey: triggerKey,
      alignment: Alignment.topLeft,
      builder: (context) {
        return const PopupCard(
          child: SizedBox(
            key: _popupChildKey,
            width: 20,
            height: 20,
          ),
        );
      },
    );

    await tester.pumpAndSettle();

    final triggerTopLeft = tester.getTopLeft(find.byKey(triggerKey));
    final popupBottomLeft = tester.getBottomLeft(find.byKey(_popupChildKey));

    expect(popupBottomLeft.dx, closeTo(triggerTopLeft.dx, 0.1));
    expect(popupBottomLeft.dy, closeTo(triggerTopLeft.dy, 0.1));
  });

  testWidgets('Anchored popup stays within screen bounds', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(240, 200);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final triggerKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              key: triggerKey,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );

    showPopupCard(
      context: tester.element(find.byType(Scaffold)),
      anchorKey: triggerKey,
      offset: const Offset(8, 8),
      builder: (context) {
        return const PopupCard(
          child: SizedBox(
            key: _popupChildKey,
            width: 180,
            height: 120,
          ),
        );
      },
    );

    await tester.pumpAndSettle();

    final screenSize = tester.view.physicalSize;
    final popupRect = tester.getRect(find.byKey(_popupChildKey));

    expect(popupRect.left, greaterThanOrEqualTo(0));
    expect(popupRect.top, greaterThanOrEqualTo(0));
    expect(popupRect.right, lessThanOrEqualTo(screenSize.width));
    expect(popupRect.bottom, lessThanOrEqualTo(screenSize.height));
  });

  testWidgets('Anchored popup stays aligned and in bounds on screen resize',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(400, 300);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    final triggerKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              key: triggerKey,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );

    showPopupCard(
      context: tester.element(find.byType(Scaffold)),
      anchorKey: triggerKey,
      alignment: Alignment.topRight,
      builder: (context) {
        return const PopupCard(
          child: SizedBox(
            key: _popupChildKey,
            width: 60,
            height: 40,
          ),
        );
      },
    );

    await tester.pumpAndSettle();

    final beforeTriggerTopRight = tester.getTopRight(find.byKey(triggerKey));
    final beforePopupBottomRight =
        tester.getBottomRight(find.byKey(_popupChildKey));

    expect(beforePopupBottomRight.dx, closeTo(beforeTriggerTopRight.dx, 0.1));
    expect(beforePopupBottomRight.dy, closeTo(beforeTriggerTopRight.dy, 0.1));

    tester.view.physicalSize = const Size(320, 260);
    await tester.pumpAndSettle();

    final afterTriggerTopRight = tester.getTopRight(find.byKey(triggerKey));
    final afterPopupBottomRight =
        tester.getBottomRight(find.byKey(_popupChildKey));
    final afterScreenSize = tester.view.physicalSize;

    expect(afterPopupBottomRight.dx, closeTo(afterTriggerTopRight.dx, 0.1));
    expect(afterPopupBottomRight.dy, lessThanOrEqualTo(afterScreenSize.height));
    expect(
      afterPopupBottomRight.dx,
      isNot(closeTo(beforePopupBottomRight.dx, 0.1)),
    );
  });
}
