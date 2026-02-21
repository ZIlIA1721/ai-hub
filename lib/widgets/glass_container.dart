import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 20,
    this.blur = 20,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark 
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.7);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? defaultColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border.all(
                color: isDark 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassSidebar extends StatelessWidget {
  final Widget child;

  const GlassSidebar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: isDark 
            ? const Color(0xFF1C1C1E).withOpacity(0.9)
            : const Color(0xFFFFFFFF).withOpacity(0.8),
        border: Border(
          right: BorderSide(
            color: isDark 
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: child,
        ),
      ),
    );
  }
}
