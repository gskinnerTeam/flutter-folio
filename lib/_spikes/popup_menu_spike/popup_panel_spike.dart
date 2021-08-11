import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_folio/_widgets/alignments.dart';
import 'package:flutter_folio/data/book_data.dart';
import 'package:flutter_folio/styles.dart';
import 'package:flutter_folio/views/editor_page/scrap_popup_editor/animated_menu_panel.dart';
import 'package:flutter_folio/views/editor_page/scrap_popup_editor/scrap_popup_editor.dart';

class PopupPanelSpike extends StatefulWidget {
  const PopupPanelSpike({Key? key}) : super(key: key);

  @override
  _PopupPanelSpikeState createState() => _PopupPanelSpikeState();
}

class _PopupPanelSpikeState extends State<PopupPanelSpike> {
  PlacedScrapItem _item = PlacedScrapItem(
    rot: 30,
    boxStyle: BoxStyle(font: BoxFonts.Caveat, align: TextAlign.center, fgColor: Colors.red, bgColor: Colors.blue),
    scale: 1,
    lastModifiedTime: 0,
    dy: 0,
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: Stack(
          children: [
            //Positioned(child: ControlPanel(), left: 100, top: 100),

            Transform.translate(
              offset: const Offset(100, 50),
              //child: _ExamplePopupPanel(),
              child: ScrapPopupEditor(
                  onRotChanged: (value) {
                    setState(() => _item = _item.copyWith(rot: value));
                  },
                  onStyleChanged: (style) {
                    setState(() => _item = _item.copyWith(boxStyle: style));
                  },
                  scrap: _item),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExamplePopupPanel extends StatefulWidget {
  @override
  _ExamplePopupPanelState createState() => _ExamplePopupPanelState();
}

class _ExamplePopupPanelState extends State<_ExamplePopupPanel> {
  int _btnIndex = -1;

  @override
  Widget build(BuildContext context) {
    AnimatedMenuPanel animatedPanel(Offset o, Size s,
        {required double openHeight, required int index, required Widget Function(bool isOpen) childBuilder}) {
      return AnimatedMenuPanel(o, s,
          openHeight: openHeight,
          key: ValueKey(index),
          isOpen: _btnIndex == index,
          isVisible: _btnIndex == index || _btnIndex == -1,
          onPressed: () => _handlePanelPressed(index),
          childBuilder: childBuilder);
    }

    timeDilation = 1;
    double row1Height = 60;
    double row2Height = 40;
    double row3Height = 0;
    double allRowsHeight = row1Height + row2Height + row3Height;
    return TopLeft(
      child: SizedBox(
        width: 300,
        height: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedOpacity(
                duration: Times.fast,
                opacity: _btnIndex >= 0 ? 0 : 1,
                child: TopLeft(
                    child: Container(
                  height: allRowsHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    // border: Border.all(color: Colors.black),
                  ),
                ))),
            ..._sortChildrenWithSelectedOnTop([
              /// TOP ROW
              animatedPanel(
                const Offset(0, 0), // Pos(row: 0, item: 0)
                Size(150, row1Height),
                index: 0,
                openHeight: 100,
                childBuilder: (bool isOpen) => Content("CONTROL-1", Colors.green, isOpen: isOpen),
              ),

              animatedPanel(
                const Offset(150, 0), // Pos(row: 0, item: 1)
                Size(150, row1Height),
                index: 1,
                openHeight: 100,
                childBuilder: (bool isOpen) => Content("CONTROL-2", Colors.red, isOpen: isOpen),
              ),

              /// MIDDLE ROW
              animatedPanel(
                Offset(0, row1Height),
                Size(150, row2Height),
                index: 2,
                openHeight: 160,
                childBuilder: (bool isOpen) => Content("CONTROL-3", Colors.blue, isOpen: isOpen),
              ),

              animatedPanel(
                Offset(150, row1Height),
                Size(150, row2Height),
                index: 3,
                openHeight: 160,
                childBuilder: (bool isOpen) => Content("CONTROL-4", Colors.orange, isOpen: isOpen),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void _handlePanelPressed(int i) {
    setState(() {
      bool wasSelected = _btnIndex == i;
      _btnIndex = wasSelected ? -1 : i; //Deselect if it was selected
    });
  }

  List<AnimatedMenuPanel> _sortChildrenWithSelectedOnTop(List<AnimatedMenuPanel> list) {
    if (_btnIndex == -1) return list;
    final panel = list.removeAt(_btnIndex);
    return list..add(panel);
  }
}

class Content extends StatelessWidget {
  const Content(this.lbl, this.color, {Key? key, required this.isOpen}) : super(key: key);
  final bool isOpen;
  final Color color;
  final String lbl;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Times.fast,
      child: Container(
        color: color,
        key: ValueKey(isOpen),
        child: Stack(fit: StackFit.expand, children: [
          if (isOpen == false) Text(lbl),
          if (isOpen) Center(child: Text(lbl, style: const TextStyle(fontSize: 32)))
        ]),
      ),
    );
  }
}
