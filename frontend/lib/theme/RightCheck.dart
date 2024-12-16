import 'package:flutter/material.dart';

class AnimatedCheck extends StatefulWidget {
  const AnimatedCheck({super.key});

  @override
  _AnimatedCheckState createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> with TickerProviderStateMixin {
  late final AnimationController scaleController;
  late final AnimationController checkController;
  late final Animation<double> scaleAnimation;
  late final Animation<double> checkAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    scaleController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    checkController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    // Initialize animations
    scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
    checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

    // Chain animations: start checkController after scaleController completes
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });

    // Start the scaling animation
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 80;
    double iconSize = 48;

    return AnimatedBuilder(
      animation: Listenable.merge([scaleController, checkController]),
      builder: (context, child) {
        return Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: SizeTransition(
                sizeFactor: checkAnimation,
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
