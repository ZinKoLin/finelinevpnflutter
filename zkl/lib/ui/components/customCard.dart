import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? shadow;
  final Color? backgroundColor;
  final double? radius;

  const CustomCard({Key? key, this.margin, this.padding, this.shadow, this.backgroundColor, this.child, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 10),
        child: Material(
          color: Colors.transparent,
          child: Padding(padding: padding ?? EdgeInsets.only(), child: child ?? SizedBox.shrink()),
        ),
      ),
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          shadow ??
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(.1),
                offset: Offset(0, 5),
              ),
        ],
      ),
    );
  }
}
