import 'package:flutter/material.dart';
import 'package:elementary/responsive/desktop_body.dart';
import 'package:elementary/responsive/mobile_body.dart';
import 'package:elementary/responsive/responsive_layout.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
