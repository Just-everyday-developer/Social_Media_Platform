import 'package:flutter/material.dart';
import 'dart:async';

class ShowUpAnimation extends StatefulWidget {
  final Widget child;
  final int? delay; // duration
  const ShowUpAnimation({super.key, required this.child, required this.delay});

  @override
  _ShowUpAnimation createState() => _ShowUpAnimation();
}
class _ShowUpAnimation extends State<ShowUpAnimation> with TickerProviderStateMixin {
    late AnimationController _animController;
    late Animation<Offset> _animOffset;
    late Timer _timer;

    @override
    void initState() {
      super.initState();

      _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
      final curve = CurvedAnimation(parent: _animController, curve: Curves.decelerate);
      _animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(curve);

    if (widget.delay == null) {
      _animController.forward();
    }
    else {
      _timer = Timer(Duration(milliseconds: widget.delay!), () {
        _animController.forward();
      });
    }
    }

    @override
    void dispose() {
      super.dispose();
      _animController.dispose();
      _timer.cancel();
    }

    @override
    Widget build(BuildContext context) {
      return FadeTransition(
        opacity: _animController,
        child: SlideTransition(
            position: _animOffset,
            child: widget.child)
      );
    }
  }
