import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(padding: EdgeInsets.all(32.0), child: SquareAnimation()),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => SquareAnimationState();
}

enum Direction { left, right, center }

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  static const double _squareSize = 50.0;

  Direction _currentDirection = Direction.center;
  Direction get currentDirection => _currentDirection;
  set currentDirection(Direction value) => setState(() {
    _currentDirection = value;
  });

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {});
      }
    });
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_animationController);
  }

  void _setOffsetAnimation({required Offset begin, required Offset end}) {
    _offsetAnimation = Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  void moveRight() {
    if (currentDirection == Direction.right) {
      return;
    }
    final double screenWidth = MediaQuery.of(context).size.width - 32;
    final double centerDx = (screenWidth - _squareSize) / 2;

    if (currentDirection == Direction.center) {
      _setOffsetAnimation(begin: Offset.zero, end: Offset(centerDx, 0));
    } else if (currentDirection == Direction.left) {
      _setOffsetAnimation(
        begin: Offset(-centerDx, 0),
        end: Offset(centerDx, 0),
      );
    }

    currentDirection = Direction.right;
  }

  void moveLeft() {
    if (currentDirection == Direction.left) {
      return;
    }
    final double screenWidth = MediaQuery.of(context).size.width - 32;
    final double centerDx = (screenWidth - _squareSize) / 2;

    if (currentDirection == Direction.center) {
      _setOffsetAnimation(begin: Offset.zero, end: Offset(-centerDx, 0));
    } else if (currentDirection == Direction.right) {
      _setOffsetAnimation(
        begin: Offset(centerDx, 0),
        end: Offset(-centerDx, 0),
      );
    }

    currentDirection = Direction.left;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _offsetAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: _offsetAnimation.value,
              child: Container(
                width: _squareSize,
                height: _squareSize,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  _animationController.isAnimating ||
                          currentDirection == Direction.left
                      ? null
                      : moveLeft,
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed:
                  _animationController.isAnimating ||
                          currentDirection == Direction.right
                      ? null
                      : moveRight,
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
