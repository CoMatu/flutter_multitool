import 'package:flutter/material.dart';
import 'package:flutter_multitool/flutter_multitool.dart';

class AnimatedSelectorWidget extends StatefulWidget {
  const AnimatedSelectorWidget({
    Key? key,
    required this.screenWidth,
    this.backgroundColor,
    this.textStyle,
    this.borderColor,
  }) : super(key: key);

  final double screenWidth;

  final Color? backgroundColor;
  final Color? borderColor;
  final TextStyle? textStyle;

  @override
  State<AnimatedSelectorWidget> createState() => _AnimatedSelectorWidgetState();
}

class _AnimatedSelectorWidgetState extends State<AnimatedSelectorWidget>
    with TickerProviderStateMixin {
  late AnimationController controllerLeft;
  late Animation animationLeft;
  late AnimationController controllerRight;
  late Animation animationRight;

  Color? activeColor = const Color(0xffffffff);
  Color inactiveColor = const Color(0xff151522);

  static const double startPostion = 4.0;
  double? endPostion;

  Color? colorLeft;
  Color? colorRight;

  double? leftPosition;

  Duration get duration => const Duration(milliseconds: 300);

  bool get _brigthnessDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();

    colorLeft = activeColor;
    colorRight = inactiveColor;

    leftPosition = startPostion;
    endPostion = (widget.screenWidth - 22) / 2;

    controllerLeft = AnimationController(vsync: this, duration: duration);
    animationLeft = ColorTween(
      begin: activeColor,
      end: inactiveColor,
    ).animate(controllerLeft);

    animationLeft.addListener(() {
      setState(() {
        colorLeft = animationLeft.value;
      });
    });
    controllerRight = AnimationController(vsync: this, duration: duration);
    animationRight = ColorTween(
      begin: inactiveColor,
      end: activeColor,
    ).animate(controllerRight);

    animationRight.addListener(() {
      setState(() {
        colorRight = animationRight.value;
      });
    });
  }

  TextStyle get textStyle => widget.textStyle ?? const TextStyle();

  Color get backgroundColor =>
      widget.backgroundColor ?? const Color(0XFFFFFFFF);

  Color get borderColor => widget.borderColor ?? const Color(0xfff2f2f2);

  @override
  void dispose() {
    controllerLeft.dispose();
    controllerRight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boxDecoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(
        Radius.circular(15),
      ),
      border: Border.all(color: borderColor, width: 0.5),
    );

    return Container(
      height: 50,
      decoration: boxDecoration,
      child: Stack(
        children: [
          AnimatedPositioned(
              top: 3,
              left: leftPosition,
              duration: duration,
              child: Container(
                height: 44,
                width: (MediaQuery.of(context).size.width / 2) - 24,
                decoration: BoxDecoration(
                  gradient: _kLinearGradientOrange,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
              )),
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Персональные',
                  style: textStyle.apply(
                      color: _brigthnessDark ? activeColor : colorLeft),
                ).gestureDetector(onTap: onTapLeft),
                Text(
                  'Корпоративные',
                  style: textStyle.apply(
                      color: _brigthnessDark ? activeColor : colorRight),
                ).gestureDetector(onTap: onTapRight),
              ],
            ),
          )
        ],
      ).horizontalSwipeDetector(onSwipe: onSwipe),
    );
  }

  void onSwipe(DragUpdateDetails details) {
    // Swiping in right direction.
    if (details.delta.dx > 0) {
      if (!controllerLeft.isAnimating && !controllerRight.isAnimating) {
        onTapRight();
      }
    }

    // Swiping in left direction.
    if (details.delta.dx < 0) {
      if (!controllerLeft.isAnimating && !controllerRight.isAnimating) {
        onTapLeft();
      }
    }
  }

  void onTapLeft() {
    if (leftPosition == endPostion) {
      startAnimation();
      setState(() {
        leftPosition = startPostion;
      });
    }
  }

  void onTapRight() {
    if (leftPosition == startPostion) {
      startAnimation();
      setState(() {
        leftPosition = endPostion;
      });
    }
  }

  void startAnimation() {
    controllerLeft.isCompleted
        ? controllerLeft.reverse()
        : controllerLeft.forward();

    controllerRight.isCompleted
        ? controllerRight.reverse()
        : controllerRight.forward();
  }

  final LinearGradient _kLinearGradientOrange = const LinearGradient(
    colors: [
      Color(0xffFC6E60),
      Color(0xffF0700B),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
