import 'package:flutter/material.dart';

class FadeTransitionSwitcher extends StatefulWidget {
  final Widget child;

  const FadeTransitionSwitcher({Key? key, required this.child}) : super(key: key);

  @override
  State<FadeTransitionSwitcher> createState() => _FadeTransitionSwitcherState();
}

class _FadeTransitionSwitcherState extends State<FadeTransitionSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: KeyedSubtree(
        key: ValueKey(Theme.of(context).brightness),
        child: widget.child,
      ),
    );
  }
}
