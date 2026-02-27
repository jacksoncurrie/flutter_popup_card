library;

import 'dart:math' as math;

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
/// The `anchorKey` argument can be used to anchor the popup to a specific
/// widget. When provided, [alignment] chooses which side/corner of the popup
/// is attached to which side/corner of the anchor, and [offset] is applied on
/// top of that anchored position.
///
/// The `useSafeArea` argument is used to place the popup inside a [SafeArea]
/// so that it can avoid intrusion of the operating system.
///
/// The `dimBackground` argument controls whether a dark modal barrier is shown
/// behind the popup.
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
///   anchorKey: _elementKey,
///   useSafeArea: true,
///   dimBackground: true,
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
  bool dimBackground = false,
  GlobalKey? anchorKey,
}) {
  return Navigator.of(context).push<T>(
    PopupCardRoute<T>(
      builder: builder,
      alignment: alignment,
      offset: offset,
      useSafeArea: useSafeArea,
      dimBackground: dimBackground,
      anchorKey: anchorKey,
    ),
  );
}

Rect? _resolveAnchorRect(BuildContext context, NavigatorState navigator) {
  final anchorObject = context.findRenderObject();
  final overlayObject = navigator.overlay?.context.findRenderObject();

  if (anchorObject is! RenderBox ||
      overlayObject is! RenderBox ||
      !anchorObject.hasSize) {
    return null;
  }

  final topLeft = anchorObject.localToGlobal(
    Offset.zero,
    ancestor: overlayObject,
  );
  return topLeft & anchorObject.size;
}

class _AnchoredPopupLayoutDelegate extends SingleChildLayoutDelegate {
  _AnchoredPopupLayoutDelegate({
    required this.anchorRect,
    required this.alignment,
    required this.offset,
    required this.insets,
  });

  final Rect anchorRect;
  final Alignment alignment;
  final Offset offset;
  final EdgeInsets insets;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final anchorX = switch (alignment.x) {
      < 0 => anchorRect.left,
      > 0 => anchorRect.right,
      _ => anchorRect.center.dx,
    };
    final popupAnchorX = switch (alignment.x) {
      < 0 => 0,
      > 0 => childSize.width,
      _ => childSize.width / 2,
    };

    final anchorY = switch (alignment.y) {
      < 0 => anchorRect.top,
      > 0 => anchorRect.bottom,
      _ => anchorRect.center.dy,
    };
    final popupAnchorY = switch (alignment.y) {
      < 0 => childSize.height,
      > 0 => 0,
      _ => childSize.height / 2,
    };

    final x = anchorX - popupAnchorX + offset.dx;
    final y = anchorY - popupAnchorY + offset.dy;

    final minX = insets.left;
    final double maxX =
        math.max(minX, size.width - insets.right - childSize.width);
    final minY = insets.top;
    final double maxY =
        math.max(minY, size.height - insets.bottom - childSize.height);

    return Offset(
      x.clamp(minX, maxX).toDouble(),
      y.clamp(minY, maxY).toDouble(),
    );
  }

  @override
  bool shouldRelayout(_AnchoredPopupLayoutDelegate oldDelegate) {
    return anchorRect != oldDelegate.anchorRect ||
        alignment != oldDelegate.alignment ||
        offset != oldDelegate.offset ||
        insets != oldDelegate.insets;
  }
}

class _PopupMetricsObserver with WidgetsBindingObserver {
  _PopupMetricsObserver(this.onMetricsChanged);

  final VoidCallback onMetricsChanged;

  @override
  void didChangeMetrics() {
    onMetricsChanged();
  }
}

/// A route that displays popup cards in the [Navigator]'s [Overlay].
///
/// See also:
///
///  * [PopupRoute], which displays widgets in the [Navigator]'s [Overlay].
class PopupCardRoute<T> extends PopupRoute<T> {
  /// Creates a route that adds the builder into a popup.
  PopupCardRoute({
    required this.builder,
    this.alignment = Alignment.center,
    this.offset = Offset.zero,
    this.useSafeArea = false,
    this.dimBackground = false,
    this.anchorKey,
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

  /// Whether the popup should dim the background behind it.
  ///
  /// This will add a dark overlay behind the popup to make the card stand out
  /// more.
  final bool dimBackground;

  /// Whether the popup should be anchored to a widget via key.
  ///
  /// This will position the popup relative to that widget using [alignment]
  /// and [offset], instead of only screen alignment.
  final GlobalKey? anchorKey;

  _PopupMetricsObserver? _metricsObserver;
  int _pendingMetricRefreshes = 0;

  @override
  void install() {
    super.install();
    _metricsObserver = _PopupMetricsObserver(_handleMetricsChanged);
    WidgetsBinding.instance.addObserver(_metricsObserver!);
  }

  @override
  void dispose() {
    if (_metricsObserver != null) {
      WidgetsBinding.instance.removeObserver(_metricsObserver!);
      _metricsObserver = null;
    }
    super.dispose();
  }

  void _handleMetricsChanged() {
    changedInternalState();
    _pendingMetricRefreshes = 3; // Rebuild 3 times to settle position
    _scheduleMetricRefresh();
  }

  void _scheduleMetricRefresh() {
    if (_pendingMetricRefreshes <= 0) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isActive) {
        _pendingMetricRefreshes = 0;
        return;
      }
      changedInternalState();
      _pendingMetricRefreshes -= 1;
      _scheduleMetricRefresh();
    });
  }

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Dismiss';

  @override
  Color? get barrierColor =>
      dimBackground ? Colors.black.withValues(alpha: 0.5) : Colors.transparent;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 160);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 160);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Depend on MediaQuery so this route rebuilds and re-resolves anchor rect
    // when screen metrics change (e.g. window resize or rotation).
    MediaQuery.sizeOf(context);
    final Widget popupChild = Builder(builder: builder);

    final resolvedAnchorRect =
        anchorKey?.currentContext != null && navigator != null
            ? _resolveAnchorRect(anchorKey!.currentContext!, navigator!)
            : null;

    Widget content;
    if (resolvedAnchorRect != null) {
      final resolvedAlignment = alignment.resolve(Directionality.of(context));
      final safeInsets =
          useSafeArea ? MediaQuery.paddingOf(context) : EdgeInsets.zero;
      content = SizedBox.expand(
        child: CustomSingleChildLayout(
          delegate: _AnchoredPopupLayoutDelegate(
            anchorRect: resolvedAnchorRect,
            alignment: resolvedAlignment,
            offset: offset,
            insets: safeInsets,
          ),
          child: Align(
            alignment: Alignment.topLeft,
            widthFactor: 1,
            heightFactor: 1,
            child: popupChild,
          ),
        ),
      );
    } else {
      content = Transform.translate(
        offset: offset,
        child: Align(
          alignment: alignment,
          child: popupChild,
        ),
      );
    }

    if (useSafeArea && resolvedAnchorRect == null) {
      content = SafeArea(child: content);
    }

    return content;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final scaleAlignment = alignment.resolve(Directionality.of(context));
    final Animation<double> curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curvedAnimation,
      child: ScaleTransition(
        alignment: scaleAlignment,
        scale: Tween<double>(begin: 0.98, end: 1).animate(curvedAnimation),
        child: child,
      ),
    );
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
