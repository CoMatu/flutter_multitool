import 'package:flutter/material.dart';

extension WidgetAppExt on Widget {
  Widget gestureDetector({
    required VoidCallback onTap,
    HitTestBehavior? behavior = HitTestBehavior.translucent,
  }) =>
      GestureDetector(
        behavior: behavior,
        onTap: onTap,
        child: this,
      );

  Widget mouseRegion({
    required VoidCallback onTap,
    HitTestBehavior? behavior = HitTestBehavior.translucent,
    MouseCursor cursor = SystemMouseCursors.click,
  }) =>
      MouseRegion(
        cursor: cursor,
        child: GestureDetector(
          behavior: behavior,
          onTap: onTap,
          child: this,
        ),
      );

  Widget expanded([int flex = 1]) => Expanded(
        flex: flex,
        child: this,
      );

  Widget scrollable(ScrollPhysics? physics) => SingleChildScrollView(
        physics: physics,
        child: this,
      );

  Widget positioned({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) =>
      Positioned(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
        child: this,
      );

  Widget positionedFill({AlignmentGeometry? alignment}) => Positioned.fill(
          child: Align(
        alignment: alignment ?? Alignment.center,
        child: this,
      ));
}

/// add Padding Property to widget
extension WidgetPaddingApp on Widget {
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);

  Widget sliverToBox({Key? key}) => SliverToBoxAdapter(
        key: key,
        child: this,
      );
}

/// Add margin property to widget
extension WidgetMarginApp on Widget {
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}
