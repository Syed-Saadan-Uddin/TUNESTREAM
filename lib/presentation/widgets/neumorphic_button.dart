import 'package:flutter/material.dart';
import '../../core/theme.dart';

class NeumorphicButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final double? size;

  const NeumorphicButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    
    final brightness = Theme.of(context).brightness;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        padding: size == null
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
            : null,
        decoration: AppTheme.neumorphicDecoration(brightness: brightness),
        child: Center(child: child),
      ),
    );
  }
}