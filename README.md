# Flutter popup card

A card to popup overtop of your main app.

A lightweight plugin for custom popup cards to be shown anywhere on the screen.

![Mobile example](#example1) ![Desktop example](#example2)

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
);
```

See full example app [here](#example).
