import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elementary/style/styles.dart';
import 'package:elementary/elements.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:js' as js;

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
                        title: Text("$i) ${myModel.categories[i].title}",
                            style: TextStyles.bodySm),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                ReorderableListView.builder(
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
                            onLongPress: () => myModel.enterEditMode(i),
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
                (myModel.elements.isEmpty)
                    ? const DonateText()
                    : const Text(''),
                (myModel.editMode)
                    ? AlertDialog(
                        title: const Text("Edit Element"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                myModel.cancelEditMode();
                              },
                              child: const Text("Cancel")),
                          ElevatedButton(
                              onPressed: () {
                                myModel.updateItem(myModel.editIndex,
                                    myModel.editThumb, myModel.editName);
                              },
                              child: const Text("Save")),
                        ],
                        content: Column(
                          children: [
                            Container(
                              color: Colors.black45,
                              child: IconButton(
                                onPressed: () {
                                  js.context.callMethod(
                                      'open', [myModel.thumbController.text]);
                                },
                                icon: CachedNetworkImage(
                                  height: 72,
                                  imageUrl: myModel.thumbController.text,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                minLines: 3,
                                maxLines: 5,
                                onChanged: (text) {
                                  myModel.refreshEditForm();
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Thumbnail Image URL:",
                                    hintText:
                                        "Enter a valid url for a graphic."),
                                controller: myModel.thumbController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                minLines: 3,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Channel Name/Description:",
                                    hintText:
                                        "Enter the text for the channel description."),
                                controller: myModel.nameController,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text(""),
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Column(
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
                                                    .moveSideBoardToBookMarkA(
                                                        i);
                                          },
                                          backgroundColor:
                                              (myModel.bookmarkA == -1)
                                                  ? Colors.black12
                                                  : Colors.red,
                                          foregroundColor:
                                              (myModel.bookmarkA == -1)
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
                                                    .moveSideBoardToBookMarkB(
                                                        i);
                                          },
                                          backgroundColor:
                                              (myModel.bookmarkB == -1)
                                                  ? Colors.black12
                                                  : Colors.blue,
                                          foregroundColor:
                                              (myModel.bookmarkB == -1)
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
                  ),
                  (myModel.elements.isEmpty)
                      ? const InstructionsText()
                      : const Text(''),
                ],
              )),
        ],
      );
    });
  }
}

class DonateText extends StatelessWidget {
  const DonateText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String appName = 'Elementary </XML>';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
              child: Text(
            'MEMORANDUM',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )),
          const Text(''),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                    text: 'To: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: 'All Users of '),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600))
              ])),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                    text: 'Subject: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: 'Introduction to '),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600))
              ])),
          const Text(''),
          const Text('Dear Valued Users,'),
          const Text(''),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text: 'We are delighted to introduce ',
                ),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        ', a new web application that saves you hours of editing your custom "favourites" file for your video viewing software. Our team has invested a significant amount of time and effort into the development of this tool, and we are excited to share it with you.'),
              ])),
          const Text(''),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text:
                      'Our goal is to create an exceptional user experience and help make your video viewing more efficient. We recognize that the best way to improve the tool is by receiving feedback from users like you. Therefore, we encourage you to share your thoughts and suggestions so that we can continue to enhance the functionality of ',
                ),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(text: '.'),
              ])),
          const Text(''),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text:
                      'We are committed to keeping this utility free of charge and have open-sourced it so that other developers can contribute to its improvement. However, if you find ',
                ),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(
                    text:
                        ' valuable and would like to support our efforts, we welcome donations of any amount. Your donation will be used to cover the cost of running and maintaining the application, as well as continuing to improve it.'),
              ])),
          const Text(''),
          const Text('To donate, please click the link below:'),
          const Text('[Insert Link]'),
          const Text(''),
          const Text('Or using Crypto:'),
          Row(children: const [
            SelectableText.rich(
                TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: 'BTC: ', style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: '1Pza2CQjGVAYcqJLNFh1F6F23dfcquLMnq'),
            ])),
            IconButton(
            iconSize: 100,
            icon: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: null,
          ),
          ]),
          Row(children: const [
            SelectableText.rich(
                TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: 'ETH: ', style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: '0xCb295423A770e553fe153cB6595840D7929b913d'),
            ]))
          ]),
          Row(children: const [
            SelectableText.rich(
                TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: 'LTC: ', style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: 'LXDy5T6p5LzFUpeV5uN5SfyWvquf9bCCJV'),
            ]))
          ]),
          Row(children: const [
            SelectableText.rich(
                TextSpan(style: TextStyle(color: Colors.black), children: [
              TextSpan(
                  text: 'ZEC: ', style: TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(text: 't1Qfw1SJ2EZTfvoFTvG7BdpHXyrUiNYhk4Q'),
            ]))
          ]),
          const Text(''),
          RichText(
              text: const TextSpan(
                  style: TextStyle(color: Colors.black),
                  children: [
                TextSpan(
                  text: 'Thank you for using ',
                ),
                TextSpan(
                    text: appName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextSpan(
                    text: ', and we look forward to hearing your feedback.'),
              ])),
          const Text(''),
          const Text('Best regards,'),
          const Text('TonyT'),
          Row(
            children: [
              SizedBox(
                  width: 32,
                  height: 32,
                  child: CachedNetworkImage(
                      imageUrl:
                          'https://upload.wikimedia.org/wikipedia/commons/9/98/Bitcoin_Sign.png')),
          SizedBox(
              width: 32,
              height: 32,
              child: CachedNetworkImage(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/f/f1/ETC_LOGO_Full_Color_Black.png')),
          SizedBox(
              width: 32,
              height: 32,
              child: CachedNetworkImage(
                  imageUrl:
                      'https://upload.wikimedia.org/wikipedia/commons/f/f8/LTC-400.png')),
          SizedBox(
              width: 32,
              height: 32,
              child: CachedNetworkImage(
                  imageUrl:
                      'https://z.cash/wp-content/uploads/2020/03/zcash-icon-fullcolor.png')),
            ],
          ),
        ],
      ),
    );
  }
}

class InstructionsText extends StatelessWidget {
  const InstructionsText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const String appName = '<b><i>Elementary &lt;/XML&gt;</i></b>';
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('''
<h3><center><b>INSTRUCTIONS</b></center></h3>

<p>1) Click "load file" button to load an XML favourites.xml file.<br>
NOTE: The file should be in the format:<br>
<pre>&lt;favourites&gt;
&nbsp;&nbsp;&lt;favourite name="Favorite name"</br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thumb="http://link_to_image"&gt;data_for_favourite...&lt;/favourite&gt;<br>
&nbsp;&nbsp;&lt;favourite ...&gt;...&lt;/favourite&gt;<br>
&nbsp;&nbsp;...<br>
&lt;/favourite></pre><br></p>

<p>2) Drag items around using the handles on the right.</p>

<p>3) Edit the item by clicking and holding the mouse button (long press).</p>

<p>4) Slide right to expose bookmark buttons to set bookmarks easily.</p>

<p>5) Slide right to move items to booksmarks, or into the Side Board.</p>

<p>6) Slide items left to move them out of the Side Board and back to the list at either bookmark A or bookmark B.</br>

<p>7) Remember to click the file button.  Only items in the Channel Descriptions column will be written to the new_favourites.xml file.</p>


<p>Happy editing...</p>

'''),
    );
  }
}
