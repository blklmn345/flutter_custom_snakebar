import 'dart:async';

import 'package:flutter/material.dart';

class CustomSnakeBarContainer extends StatefulWidget {
  // final Widget child;
  final WidgetBuilder builder;

  const CustomSnakeBarContainer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<CustomSnakeBarContainer> createState() =>
      CustomSnakeBarContainerState();

  static CustomSnakeBarContainerState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_CustomSnakeBarScope>()!;

    return scope._customSnakeBarState;
  }
}

class CustomSnakeBarContainerState extends State<CustomSnakeBarContainer>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<Offset> _animationSlide;
  late final Animation<double> _animationFade;

  bool show = false;

  _SnakeBarModel? _snakeBarModel;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationSlide =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _CustomSnakeBarScope(
      state: this,
      child: Builder(
        builder: (context) {
          return Stack(
            children: [
              widget.builder(context),
              if (_snakeBarModel != null)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: FadeTransition(
                    opacity: _animationFade,
                    child: SlideTransition(
                      position: _animationSlide,
                      child: Container(
                        height: 69,
                        color: _snakeBarModel!.type == SnakeType.success
                            ? Colors.blue
                            : Colors.red,
                        child: SafeArea(
                          child: Center(
                            child: Text(_snakeBarModel!.message),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      ),
    );
  }

  showSnakeBar({
    required SnakeType type,
    required String message,
  }) {
    setState(() {
      if (_animationController.isCompleted ||
          _animationController.isAnimating) {
        _animationController.reset();
      }

      _snakeBarModel = _SnakeBarModel(type: type, message: message);
      _animationController.forward().whenComplete(
            () => Future.delayed(
              const Duration(seconds: 5),
            ).whenComplete(
              () => _animationController.reverse(),
            ),
          );
    });
  }
}

class _CustomSnakeBarScope extends InheritedWidget {
  const _CustomSnakeBarScope({
    Key? key,
    required Widget child,
    required CustomSnakeBarContainerState state,
  })  : _customSnakeBarState = state,
        super(key: key, child: child);

  final CustomSnakeBarContainerState _customSnakeBarState;

  @override
  bool updateShouldNotify(_CustomSnakeBarScope oldWidget) {
    return oldWidget._customSnakeBarState != _customSnakeBarState;
  }
}

enum SnakeType {
  success,
  error,
}

class _SnakeBarModel {
  final SnakeType type;
  final String message;

  _SnakeBarModel({
    required this.type,
    required this.message,
  });
}
