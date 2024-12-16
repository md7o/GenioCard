import 'package:flutter/material.dart';

class RightCheckAnimation extends StatefulWidget {
  final double size;
  final Color checkColor;
  final Color backgroundColor;
  final Duration duration;

  const RightCheckAnimation({
    Key? key,
    this.size = 100.0,
    this.checkColor = Colors.green,
    this.backgroundColor = Colors.white,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _RightCheckAnimationState createState() => _RightCheckAnimationState();
}

class _RightCheckAnimationState extends State<RightCheckAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Circle scale animation
    _circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Check mark drawing animation
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _CheckPainter(
            circleProgress: _circleAnimation.value,
            checkProgress: _checkAnimation.value,
            checkColor: widget.checkColor,
            backgroundColor: widget.backgroundColor,
          ),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
          ),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  final double circleProgress;
  final double checkProgress;
  final Color checkColor;
  final Color backgroundColor;

  _CheckPainter({
    required this.circleProgress,
    required this.checkProgress,
    required this.checkColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle paint
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Animated circle paint
    final circlePaint = Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    // Draw circle
    canvas.drawCircle(center, radius * 0.8 * circleProgress, circlePaint);

    // Check mark path
    if (checkProgress > 0) {
      final checkPaint = Paint()
        ..color = checkColor
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 4.0;

      final path = Path();
      final startPoint = Offset(center.dx - radius * 0.4, center.dy + radius * 0.1);
      final middlePoint = Offset(center.dx - radius * 0.1, center.dy + radius * 0.4);
      final endPoint = Offset(center.dx + radius * 0.4, center.dy - radius * 0.2);

      path.moveTo(startPoint.dx, startPoint.dy);

      // Animate first line of check mark
      final firstLineEnd = Offset.lerp(startPoint, middlePoint, checkProgress)!;
      path.lineTo(firstLineEnd.dx, firstLineEnd.dy);

      // Animate second line of check mark
      if (checkProgress > 0.5) {
        final secondLineEnd = Offset.lerp(middlePoint, endPoint, (checkProgress - 0.5) * 2)!;
        path.lineTo(secondLineEnd.dx, secondLineEnd.dy);
      }

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckPainter oldDelegate) {
    return oldDelegate.circleProgress != circleProgress || oldDelegate.checkProgress != checkProgress;
  }
}
