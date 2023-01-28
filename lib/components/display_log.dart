import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/elements.dart';

class DisplayLog extends StatelessWidget {
  const DisplayLog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ElementsType>(builder: (context, myModel, child) {
      return Container(
        color: Colors.white,
        height: 60,
        width: double.infinity,
        child: Text('result: ${myModel.notes}'),
      );
    });
  }
}
