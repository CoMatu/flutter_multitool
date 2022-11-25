import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({
    Key? key,
    this.color = Colors.grey,
    this.size = 8.0,
    this.colors,
    this.numberOfDots = 3,
  }) : super(key: key);

  final Color color;
  final List<Color>? colors;
  final int numberOfDots;
  final double size;

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;

  final List<Animation<double>> _animations = [];

  static const animationDuration = 200;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    ///initialization of _animationControllers
    ///each _animationController will have same animation duration
    _animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: animationDuration),
        );
      },
    ).toList();

    ///initialization of _animations
    ///here end value is -20
    ///end value is amount of jump.
    ///and we want our dot to jump in upward direction
    for (int i = 0; i < widget.numberOfDots; i++) {
      _animations.add(
          Tween<double>(begin: 0, end: -8).animate(_animationControllers[i]));
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      _animationControllers[i].addStatusListener((status) {
        //On Complete
        if (status == AnimationStatus.completed) {
          //return of original postion
          _animationControllers[i].reverse();
          //if it is not last dot then start the animation of next dot.
          if (i != widget.numberOfDots - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        //if last dot is back to its original postion then start animation of the first dot.
        // now this animation will be repeated infinitely
        if (i == widget.numberOfDots - 1 &&
            status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }

    //trigger animtion of first dot to start the whole animation.
    _animationControllers.first.forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.numberOfDots,
            (index) => AnimatedBuilder(
                  animation: _animationControllers[index],
                  builder: (context, child) {
                    return Container(
                      padding: const EdgeInsets.all(2.0),
                      child: Transform.translate(
                          offset: Offset(0, _animations[index].value),
                          child: child),
                    );
                  },
                  child: DotWidget(
                    color: widget.colors != null
                        ? widget.colors![index]
                        : widget.color,
                    size: widget.size,
                  ),
                )),
      ),
    );
  }
}

class DotWidget extends StatelessWidget {
  const DotWidget({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      height: size,
      width: size,
    );
  }
}
