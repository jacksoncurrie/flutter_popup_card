# Flutter popup card

[![pub package](https://img.shields.io/pub/v/flutter_popup_card.svg)](https://pub.dev/packages/flutter_popup_card)

A lightweight plugin to create a card or custom widget that can popup overtop of your main app.

![Mobile example image](https://github.com/jacksoncurrie/flutter_popup_card/blob/main/.docs/mobile-image.png?raw=true)
![Mobile example recording](https://github.com/jacksoncurrie/flutter_popup_card/blob/main/.docs/mobile-recording.gif?raw=true)

## Usage

This plugin is based off the `showDialog` function built in to Flutter and operates very similarly.

To show a popup use `showPopupCard`.

Use the `PopupCard` widget for a Material style look.

This sample shows how to show a simple yellow popup card:

```dart
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
        child: Text('This is a popup card'),
      ),
    );
  },
  offset: const Offset(-16, 70),
  alignment: Alignment.topRight,
  useSafeArea: true,
);
```

See full example app [here](https://github.com/jacksoncurrie/flutter_popup_card/tree/main/example).
