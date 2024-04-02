import 'package:flutter/material.dart';

class ButtonZoomMap extends StatelessWidget {
  final Function()? onPressed;
  final String? tooltip;
  final Widget? child;
  const ButtonZoomMap({Key? key, this.onPressed, this.tooltip, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      mini: true,
      tooltip: tooltip,
      heroTag: null,
      child: child,
    );
  }
}
