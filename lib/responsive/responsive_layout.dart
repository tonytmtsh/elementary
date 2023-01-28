import 'package:flutter/material.dart';
import 'dimensions.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;

  const ResponsiveLayout({super.key, required this.mobileBody, required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ElementsType>(
      create: (context) => ElementsType(),
      child: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < mobileWidth) {
          return mobileBody;
        } else {
          return desktopBody;
        }
      },
      )
      );
  }
}