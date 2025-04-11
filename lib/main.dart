import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
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

/// SquareAnimation of the cube container
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => SquareAnimationState();
}

/// The different observable direction made by the cube
enum Direction { left, right, center }

/// State of the [SquareAnimation] used with [SingleTickerProviderStateMixin] for the animation.
class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  // Controls the animation timing and lifecycle
  late final AnimationController _animationController;

  // Defines the animation for offset movement (used for sliding or directional motion)
  late Animation<Offset> _offsetAnimation;

  // The fixed size of the animated square
  static const double _squareSize = 50.0;

  // Tracks the current direction of the animated object
  Direction _currentDirection = Direction.center;

  // Getter to access the current direction
  Direction get currentDirection => _currentDirection;

  // Setter that updates the direction and triggers a UI rebuild
  set currentDirection(Direction value) => setState(() {
    _currentDirection = value;
  });

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ), // Duration of 1 second as specified in the task
    )..addStatusListener((AnimationStatus status) {
      // [addStatusListener] to update _animationController.isAnimating when animation is completed
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

  // Sets up and starts the offset animation from one position to another
  void _setOffsetAnimation({required Offset begin, required Offset end}) {
    _offsetAnimation = Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.reset();
    _animationController.forward();
  }

  // Moves the square to the right side of the screen if it's not already there
  // And updates [currentDirection]
  void _moveRight() {
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

  // Moves the square to the left side of the screen if it's not already there
  // And updates [currentDirection]
  void _moveLeft() {
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
              // Disable the button if an animation is running or if it's already on the left
              onPressed:
                  _animationController.isAnimating ||
                          currentDirection == Direction.left
                      ? null
                      : _moveLeft,
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              // Disable the button if an animation is running or if it's already on the right
              onPressed:
                  _animationController.isAnimating ||
                          currentDirection == Direction.right
                      ? null
                      : _moveRight,
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
