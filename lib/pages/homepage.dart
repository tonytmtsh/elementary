import 'package:flutter/material.dart';
import 'package:elementary/responsive/desktop_body.dart';
import 'package:elementary/responsive/mobile_body.dart';
import 'package:elementary/responsive/responsive_layout.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileBody: MyMobileBody(),
        desktopBody: MyDesktopBody(),
      ),
    );
  }
}
