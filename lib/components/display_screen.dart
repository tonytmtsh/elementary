import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/style/styles.dart';
import 'package:elementary/elements.dart';

class DisplayScreen extends StatelessWidget {
  const DisplayScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ElementsType>(builder: (context, myModel, child) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              controller: myModel.scrollController,
              reverse: false,
              itemCount: myModel.elements.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    dense: true,
                    leading: CachedNetworkImage(
                      imageUrl: myModel.elements[i].thumb,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(myModel.elements[i].name,
                        style: TextStyles.body.bold),
                    trailing: Text('${myModel.elements[i].id}'),
                  ),
                );
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
            flex: 1,
            child: ListView.builder(
              controller: myModel.scrollController,
              reverse: false,
              itemCount: myModel.elements.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    dense: true,
                    leading: CachedNetworkImage(
                      imageUrl: myModel.elements[i].thumb,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(myModel.elements[i].name,
                        style: TextStyles.body.bold),
                    trailing: Text('${myModel.elements[i].id}'),
                  ),
                );
              },
            ),
          ),
                  Expanded(
            flex: 1,
            child: ListView.builder(
              controller: myModel.scrollAController,
              reverse: false,
              itemCount: myModel.elements.length,
              itemBuilder: (context, i) {
                return Card(
                  child: ListTile(
                    dense: true,
                    leading: CachedNetworkImage(
                      imageUrl: myModel.elements[i].thumb,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    title: Text(myModel.elements[i].name,
                        style: TextStyles.body.bold),
                    trailing: Text('${myModel.elements[i].id}'),
                  ),
                );
              },
            ),
          ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          color: Colors.red,
                          child: ListView.builder(
                            controller: myModel.scrollBController,
                            reverse: false,
                            itemCount: myModel.sideboard.length,
                            itemBuilder: (context, i) {
                              return Card(
                                child: ListTile(
                                  dense: true,
                                  leading: CachedNetworkImage(
                                    imageUrl: myModel.sideboard[i].thumb,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  title: Text(myModel.sideboard[i].name,
                                      style: TextStyles.body.bold),
                                  trailing: Text('${myModel.sideboard[i].id}'),
                                ),
                              );
                            },
                          ))),
                ],
              )),
        ],
      );
    });
  }
}
