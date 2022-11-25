// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:math' as m;
import 'dart:ui';

import 'package:flutter/material.dart';

class Fireworks extends StatefulWidget {
  const Fireworks({
    Key? key,
    this.itemCount = 12,
    required this.size,
    required this.itemWidthMin,
    required this.itemWidthMax,
    this.delayStart = 0,
    this.duration = 1000,
    this.color = Colors.red,
  }) : super(key: key);

  /// Количество точек по окружности
  final int itemCount;

  /// Стартовый диаметр точки
  final double itemWidthMin;

  /// Диаметр точки в конце анимации
  final double itemWidthMax;

  /// Цвет точки
  final Color color;

  /// Размер холста
  final Size size;

  /// Задержка старта анимации, миллисекунд
  final int delayStart;

  /// Длительность анимации фейерверка, миллисекунд
  final int duration;

  @override
  State<Fireworks> createState() => _FireworksState();
}

class _FireworksState extends State<Fireworks> with TickerProviderStateMixin {
  final List<double> positions = [];

  double radius = 0.0;
  double itemWidthMin = 2.0;
  double itemWidthMax = 12.0;

  late final AnimationController controller;
  late final AnimationController sizeController;

  /// Тип анимации для скорости разлёта точек
  late final Animation<double> animation;

  /// Тип анимации для изменения размера (диаметра) точек
  late final Animation<double> animationSize;

  late final Duration delay;

  @override
  void initState() {
    super.initState();

    delay = Duration(milliseconds: widget.delayStart);

    itemWidthMin = widget.itemWidthMin;
    itemWidthMax = widget.itemWidthMax;

    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ))
      ..addListener(animationListener);

    sizeController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ))
      ..addListener(animationListener);

    animation =
        Tween(begin: 0.0, end: widget.size.height / 2).animate(controller);

    final _animationSize = CurvedAnimation(
      parent: sizeController,
      curve: Curves.easeIn,
    );

    animationSize =
        Tween(begin: 0.0, end: itemWidthMax).animate(_animationSize);

    Future.delayed(delay).then((value) => controller.forward());
    Future.delayed(delay).then((value) => sizeController.forward());
  }

  void animationListener() async {
    if (controller.isCompleted) {
      controller.repeat();
      sizeController.repeat();
    }

    setState(() {
      radius = animation.value;
      itemWidthMin = animationSize.value;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FireworksCanvas(
      radius: radius,
      itemWidth: itemWidthMin,
      itemNumber: widget.itemCount,
      size: widget.size,
      color: widget.color,
    );
  }
}

class FireworksCanvas extends StatelessWidget {
  const FireworksCanvas({
    Key? key,
    required this.radius,
    required this.itemWidth,
    required this.itemNumber,
    required this.size,
    required this.color,
  }) : super(key: key);

  final double radius;
  final double itemWidth;
  final int itemNumber;
  final Size size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // log(radius.toString());

    return CustomPaint(
      size: size,
      painter: FireworksPainter(
        radius: radius,
        itemNumber: itemNumber,
        itemWidth: itemWidth,
        color: color,
      ),
    );
  }
}

class FireworksPainter extends CustomPainter {
  final double radius;
  final int itemNumber;
  final double itemWidth;
  final Color color;

  FireworksPainter({
    required this.radius,
    required this.itemWidth,
    required this.color,
    this.itemNumber = 12,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = itemWidth
      ..strokeCap = StrokeCap.round
      ..color = color;

    final points = List.generate(
      itemNumber,
      (index) {
        final double angle =
            (2 * m.pi / itemNumber) + (2 * m.pi / itemNumber) * (index + 1);
        return Offset(
          size.width / 2 + radius * m.cos(angle),
          size.width / 2 + radius * m.sin(angle),
        );
      },
    );

    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
