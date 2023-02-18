import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/style/styles.dart';
import 'package:elementary/elements.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
            child: Container(
              color: const Color.fromARGB(156, 224, 208, 58),
              child: ListView.builder(
                  reverse: false,
                  itemCount: myModel.categories.length,
                  itemBuilder: (context, i) {
                    return Card(
                      color: const Color.fromARGB(156, 224, 208, 58),
                      child: ListTile(
                        onTap: () {
                          myModel.positionCategory(myModel.categories[i].id);
                        },
                        dense: true,
                        title: Text(myModel.categories[i].title,
                            style: TextStyles.bodySm),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: ReorderableListView.builder(
              reverse: false,
              scrollController: myModel.scrollController,
              itemCount: myModel.elements.length,
              itemBuilder: (context, i) {
                return Slidable(
                  key: ValueKey(myModel.elements[i].id),
                  closeOnScroll: false,
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          myModel.setBookMarkA(i);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.save,
                        label: 'set A',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          myModel.setBookMarkB(i);
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.save_sharp,
                        label: 'set B',
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: const StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          (myModel.bookmarkA == -1)
                              ? null
                              : myModel.moveToBookMarkA(i);
                        },
                        backgroundColor: (myModel.bookmarkA == -1)
                            ? Colors.black12
                            : Colors.red,
                        foregroundColor: (myModel.bookmarkA == -1)
                            ? Colors.grey
                            : Colors.white,
                        icon: Icons.switch_account_sharp,
                        label: 'to A',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          (myModel.bookmarkB == -1)
                              ? null
                              : myModel.moveToBookMarkB(i);
                        },
                        backgroundColor: (myModel.bookmarkB == -1)
                            ? Colors.black12
                            : Colors.blue,
                        foregroundColor: (myModel.bookmarkB == -1)
                            ? Colors.grey
                            : Colors.white,
                        icon: Icons.switch_account,
                        label: 'to B',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) {
                          myModel.moveToSideBoard(i);
                        },
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.swap_horiz,
                        label: 'to sideboard',
                      ),
                    ],
                  ),
                  child: Card(
                    key: ValueKey(myModel.elements[i].id),
                    //color: Colors.grey,
                    child: SizedBox(
                      height: 40,
                      child: ListTile(
                        key: ValueKey(myModel.elements[i].id),
                        dense: true,
                        onTap: () => myModel.setSelectedElement(i),
                        tileColor: (i == myModel.bookmarkA
                            ? Colors.red
                            : (i == myModel.bookmarkB
                                ? Colors.blue
                                : (myModel.selectedElement == i)
                                    ? Colors.purple
                                    : (myModel.elements[i].name
                                            .startsWith("[COLORyellow]"))
                                        ? const Color.fromARGB(
                                            156, 224, 208, 58)
                                        : const Color.fromARGB(
                                            255, 238, 231, 231))),
                        selectedColor: Colors.orange,
                        selected: (i == myModel.selectedElement),
                        leading: CachedNetworkImage(
                          height: 36,
                          imageUrl: myModel.elements[i].thumb,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.image_not_supported),
                        ),
                        title: Text(myModel.elements[i].name,
                            style: TextStyles.bodySm),
                      ),
                    ),
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                myModel.swapElements(oldIndex, newIndex);
              },
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                          color: const Color.fromARGB(255, 115, 167, 123),
                          child: ReorderableListView.builder(
                            onReorder: (int oldIndex, int newIndex) {
                              myModel.swapSideBoard(oldIndex, newIndex);
                            },
                            reverse: false,
                            itemCount: myModel.sideboard.length,
                            itemBuilder: (context, i) {
                              return Slidable(
                                key: ValueKey(myModel.elements[i].id),
                                closeOnScroll: false,
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        (myModel.bookmarkA == -1)
                                            ? null
                                            : myModel
                                                .moveSideBoardToBookMarkA(i);
                                      },
                                      backgroundColor: (myModel.bookmarkA == -1)
                                          ? Colors.black12
                                          : Colors.red,
                                      foregroundColor: (myModel.bookmarkA == -1)
                                          ? Colors.grey
                                          : Colors.white,
                                      icon: Icons.arrow_circle_left,
                                      label: 'to A',
                                    ),
                                    SlidableAction(
                                      onPressed: (BuildContext context) {
                                        (myModel.bookmarkB == -1)
                                            ? null
                                            : myModel
                                                .moveSideBoardToBookMarkB(i);
                                      },
                                      backgroundColor: (myModel.bookmarkB == -1)
                                          ? Colors.black12
                                          : Colors.blue,
                                      foregroundColor: (myModel.bookmarkB == -1)
                                          ? Colors.grey
                                          : Colors.white,
                                      icon: Icons.arrow_left,
                                      label: 'to B',
                                    ),
                                  ],
                                ),
                                child: Card(
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
                                        style: TextStyles.bodySm),
                                  ),
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
