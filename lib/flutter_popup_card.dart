library flutter_popup_card;

import 'package:flutter/material.dart';

/// Displays a Material dialog above the current contents of the app, with
/// Material entrance and exit animations, modal barrier color, and modal
/// barrier behavior (dialog is dismissible with a tap on the barrier).
///
/// This function takes a `builder` which typically builds a [PopupCard] widget.
///  The widget returned by the `builder` does not share a context with the
/// location that [showPopupCard] is originally called from. Use a
/// [StatefulBuilder] or a custom [StatefulWidget] if the dialog needs to update
/// dynamically.
///
/// The `context` argument is used to look up the [Navigator] for
/// the overlay. It is only used when the method is called. Its corresponding
/// widget can be safely removed from the tree before the popup is closed.
///
/// The `alignment` argument is used to align the popup inside the screen. Use
/// this to position the popup to the area on the screen where it should be
/// shown. Use with [offset] to fine tune the position of the popup.
///
/// The `offset` argument is used to fine tune the position of the popped up
/// widget. Use with [alignment] for positioning of the popup.
///
/// The `useSafeArea` argument is used to place the popup inside a [SafeArea]
/// so that it can avoid intrusion of the operating syste.
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// {@tool snippet}
///
/// This sample shows how to show a simple yellow popup card:
///
/// ```dart
/// showPopupCard(
///   context: context,
///   builder: (context) {
///     return PopupCard(
///       elevation: 8,
///       color: Colors.yellow,
///       shape: RoundedRectangleBorder(
///         borderRadius: BorderRadius.circular(12.0),
///       ),
///       child: const Padding(
///         padding: EdgeInsets.all(16.0),
///         child: Text('This is a popup card'),
///       ),
///     );
///   },
///   offset: const Offset(-16, 70),
///   alignment: Alignment.topRight,
///   useSafeArea: true,
/// );
/// ```
///
/// {@end-tool}
///
/// See also:
///
///  * [PopupCard], for a card to display as the popup.
///  * [showDialog], which is what this method is based off and displays a
///  Material dialog.
Future<T?> showPopupCard<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  AlignmentGeometry alignment = Alignment.center,
  Offset offset = Offset.zero,
  bool useSafeArea = false,
}) {
  return Navigator.of(context).push<T>(
    PopupCardRoute<T>(
      builder: builder,
      alignment: alignment,
      offset: offset,
      useSafeArea: useSafeArea,
    ),
  );
}

/// A route that displays popup cards in the [Navigator]'s [Overlay].
///
/// See also:
///
///  * [OverlayRoute], which displays widgets in the [Navigator]'s [Overlay].
class PopupCardRoute<T> extends OverlayRoute<T> {
  /// Creates a route that adds the builder into a popup.
  PopupCardRoute({
    required this.builder,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.useSafeArea = false,
  });

  /// The builder that creates the widget to be popped up.
  ///
  /// See [PopupCard] for an easy widget to build in the popup.
  final WidgetBuilder builder;

  /// The alignment of the widget inside the whole screen
  ///
  /// Move this as close to the position as you like and use [offset] to
  /// position it finer.
  final AlignmentGeometry alignment;

  /// The offset of the popped up widget.
  ///
  /// Used to fine tune the position of the popup.
  ///
  /// See [alignment] for aligning the popup in the screen.
  final Offset offset;

  /// Whether the popup should begin within a safe area widget.
  ///
  /// This will put the popup outside of intrusions of the operating system.
  final bool useSafeArea;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    final innerWidget = Transform.translate(
      offset: offset,
      child: Align(
        alignment: alignment,
        child: GestureDetector(
          onTap: () {}, // Stops removing when inside clicked
          child: Material(
            color: Colors.transparent,
            child: Builder(builder: builder),
          ),
        ),
      ),
    );

    return [
      OverlayEntry(
        builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: Navigator.of(context).maybePop,
            child: useSafeArea ? SafeArea(child: innerWidget) : innerWidget,
          );
        },
      ),
    ];
  }
}

/// A Material Design style popup card: a panel with slightly rounded corners and an
/// elevation shadow.
///
/// A popup card is used to show any information (or Widget) on a panel
/// overlaid on the main app.
///
/// {@tool snippet}
///
/// This sample shows a simple yellow popup card with text inside and
/// rounded corners:
///
/// ```dart
/// PopupCard(
///   elevation: 8,
///   color: Colors.yellow,
///   shape: RoundedRectangleBorder(
///     borderRadius: BorderRadius.circular(12.0),
///   ),
///   child: const Padding(
///     padding: EdgeInsets.all(16.0),
///     child: Text('This is a popup card'),
///   ),
/// )
/// ```
///
/// {@end-tool}
///
/// See also:
///
///  * [Card], to display icons and text in a card.
///  * [showPopupCard], to display this popup card.
///  * [PopupCardRoute], to add a popup card to the navigation stack.
class PopupCard extends StatelessWidget {
  /// Creates a popup card widget.
  ///
  /// A child is required.
  const PopupCard({
    required this.child,
    this.elevation = 6,
    this.color,
    this.shape,
    super.key,
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// The z-coordinate at which to place this card. This controls the size of
  /// the shadow below the card.
  ///
  /// Defines the card's [Material.elevation].
  ///
  /// The following elevations have defined shadows: 1, 2, 3, 4, 6, 8, 9, 12, 16, 24.
  ///
  /// If this property is null then uses 6
  final int elevation;

  /// If provided, the background color used for the popup card.
  ///
  /// If this property is null, then Theme.of(context).cardColor is used.
  final Color? color;

  /// The shape of the popup card.
  ///
  /// If this property is null then Theme.of(context).popupMenuTheme.shape is
  /// used. If that's null then the shape will be a [RoundedRectangleBorder]
  /// with a circular corner radius of 4.0.
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color ?? Theme.of(context).cardColor,
        shape: shape ??
            Theme.of(context).popupMenuTheme.shape ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        shadows: elevation == 0 ? null : kElevationToShadow[elevation],
      ),
      child: child,
    );
  }
}
