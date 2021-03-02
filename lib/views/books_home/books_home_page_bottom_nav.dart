import 'package:flutter/material.dart';
import 'package:flutter_folio/core_packages.dart';
import 'package:provider/provider.dart';

import 'create_folio_bottom_sheet_content.dart';

class BooksHomePageBottomNav extends StatelessWidget {
  final bool showListView;
  final void Function(bool) onToggled;
  final VoidCallback onNewPressed;

  BooksHomePageBottomNav({this.showListView = true, this.onToggled, this.onNewPressed});

  Widget build(BuildContext context) {
    AppTheme theme = Provider.of(context);

    Color flowListBtnColor = showListView ? theme.greyMedium : theme.accent1;
    Color sortableListBtnColor = showListView ? theme.accent1 : theme.greyMedium;
    double menuHeight = 56;
    return Stack(
      children: [
        /// White Bg with shadow
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: menuHeight,
            decoration: BoxDecoration(color: theme.surface1, boxShadow: Shadows.universal),
          ),
        ),
        // Flow view button

        /// Bottom Btns
        Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Flexible(
                    child: SimpleBtn(
                  child: Container(
                      width: double.infinity,
                      height: menuHeight,
                      child: MaterialIcon(Icons.view_module_rounded, size: FontSizes.s24, color: flowListBtnColor)),
                  onPressed: () => onToggled(false),
                )),
                Flexible(
                    child: SimpleBtn(
                  child: Container(
                      width: double.infinity,
                      height: menuHeight,
                      child: MaterialIcon(Icons.view_list_rounded, size: FontSizes.s24, color: sortableListBtnColor)),
                  onPressed: () => onToggled(true),
                )),
              ],
            )),

        // New folio button
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: Insets.med),
            child: _MobileNewFolioBtn(),
          ),
        ),
      ],
    );
  }
}

class _MobileNewFolioBtn extends StatelessWidget {
  Widget build(BuildContext context) {
    void _handleNewPressed() => showStyledBottomSheet(context, child: CreateFolioBottomSheetContent());

    Decoration circleDec(Color c) => ShapeDecoration(shape: CircleBorder(), color: c);
    AppTheme theme = Provider.of(context);
    double size = 72;
    return SimpleBtn(
      cornerRadius: 99,
      onPressed: _handleNewPressed,
      // Add some padding, so we get a mouse-over effect from the SimpleBtn
      child: Padding(
        padding: EdgeInsets.all(Insets.sm),
        child: Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(8),
          decoration: circleDec(theme.surface1),
          child: Container(
            decoration: circleDec(theme.accent1),
            child: Center(
              child: MaterialIcon(Icons.add, size: size * .8, color: theme.surface1),
            ),
          ),
        ),
      ),
    );
  }
}
